//
//  StatService.swift
//  RaspStat
//
//  Created by Hanif Shersy on 27/3/2022.
//

import Foundation
import Combine

struct StatString: Decodable {
    var data: String
}

let unknownStat = StatString(data: "??")

class HostServerConfig : ObservableObject {
    var host: String
    var port: Int
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    func url(path: String = "", http: Bool = true) -> String {
        return "\(http ? "http://" : "")\(host):\(port)/\(path)"
    }
}

class StatService: ObservableObject {
    static var shared = StatService()
    
    @Published var cpuStat: String = ""
    @Published var gpuStat: String = ""
    @Published var memFreeStat: String = ""
    @Published var memTotalStat: String = ""
    @Published var tempStat: String = ""
    @Published var throttledStat: String = ""
    @Published var voltsStat: String = ""
    
    @Published var shutdownEnabled: Bool = true
    
    var prevCancellables: [AnyCancellable] = []
    
    func requestInstantStats(stat: String, config: HostServerConfig) {
        guard let url = URL(string: config.url(path: stat)) else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", url.absoluteString, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(StatString.self, from: data)
                        switch (stat) {
                        case "cpu":
                            self.cpuStat = decoded.data
                        case "gpu":
                            self.gpuStat = decoded.data
                        case "memFree":
                            self.memFreeStat = decoded.data
                        case "memTotal":
                            self.memTotalStat = decoded.data
                        case "throttled":
                            self.throttledStat = decoded.data
                        case "temp":
                            self.tempStat = decoded.data
                        case "volts":
                            self.voltsStat = decoded.data
                        default:
                            break;
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func requestInstantStatsPublisher(for stat: String, config: HostServerConfig) -> Publishers.ReplaceError<Publishers.Decode<Publishers.Map<URLSession.DataTaskPublisher, JSONDecoder.Input>, StatString, JSONDecoder>> {

        guard let url = URL(string: config.url(path: stat)) else { fatalError("Missing URL") }
        let dataTask = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type:  StatString.self, decoder: JSONDecoder())
            .replaceError(with: unknownStat)
            
        return dataTask
    }
    
    func requestManyStatsInstant(stats: [String], config: HostServerConfig) {
        if !prevCancellables.isEmpty {
            prevCancellables.forEach { $0.cancel() }
        }
        
        prevCancellables = stats
            .map { stat in
                requestInstantStatsPublisher(for: stat, config: config)
                    .receive(on: DispatchQueue.main, options: .none)
                    .sink(receiveCompletion: { _ in }) { decoded in
//                        print(stat)
                        switch (stat) {
                        case "cpu":
                            self.cpuStat = decoded.data
                        case "gpu":
                            self.gpuStat = decoded.data
                        case "memFree":
                            self.memFreeStat = decoded.data
                        case "memTotal":
                            self.memTotalStat = decoded.data
                        case "throttled":
                            self.throttledStat = decoded.data
                        case "temp":
                            self.tempStat = decoded.data
                        case "volts":
                            self.voltsStat = decoded.data
                        default:
                            break;
                        }
                    }
            }
        
    }
    
    func requestShutdown(config: HostServerConfig) {
        guard let url = URL(string: config.url(path: "power/off/1")) else { fatalError("Missing URL") }
        self.shutdownEnabled = false
        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                print("Error trying to shutdown", err)
                DispatchQueue.main.async {
                    self.shutdownEnabled = true
                }
                return
            }
            DispatchQueue.main.async {
                self.shutdownEnabled = true
            }
        }.resume()
    }
    
    func requestRestart(config: HostServerConfig) {
        guard let url = URL(string: config.url(path: "power/reboot")) else { fatalError("Missing URL") }
        self.shutdownEnabled = false
        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                print("Error trying to reboot", err)
                DispatchQueue.main.async {
                    self.shutdownEnabled = true
                }
                return
            }
        }.resume()
    }
}
