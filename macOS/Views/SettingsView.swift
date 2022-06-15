//
//  SettingsView.swift
//  RaspStat (macOS)
//
//  Created by Hanif Shersy on 15/6/2022.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingsKey.autoReconnect.rawValue) private var autoReconnect = true
    @AppStorage(SettingsKey.fetchInterval.rawValue) private var fetchIntervalSeconds = 3.0
    @AppStorage(SettingsKey.hostPort.rawValue) private var port = "4333"
    @AppStorage(SettingsKey.hostAddress.rawValue) private var host = "pi.local"
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Form {
                Text("Server Details").font(.headline)
                TextField("Address", text: $host).disableAutocorrection(true)
                TextField("Port", text: $port).disableAutocorrection(true)
                
                Text("Fetch").font(.headline)
                Toggle("Auto-connect if unreachable", isOn: $autoReconnect)
                Slider(value: $fetchIntervalSeconds, in: 1...60) {
                    Text("Fetch (\(fetchIntervalSeconds, specifier: "%02.0f") s)")
                        .frame(width: 100)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 48)
        .frame(width: 350, height: 100)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
