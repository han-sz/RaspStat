//
//  ContentView.swift
//  Shared
//
//  Created by Hanif Shersy on 16/3/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var statService: StatService
    @EnvironmentObject var hostConfig: HostServerConfig
    
    @State var isEditingViewShown = false
    
    let timer = Timer
        .publish(every: 1.5, tolerance: 2, on: .main, in: .default)
//        .map { StatService.shared.requestInstantStatsPublisher(for: "temp", config: hostConfig }
        .autoconnect()
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
#if os(macOS)
            ScrollView(showsIndicators: false) {
                StatListView()
                ActionsView(
                    shutdownEnabled: statService.shutdownEnabled,
                    performShutdown: { statService.requestShutdown(config: hostConfig) },
                    performRestart: { statService.requestReboot(config: hostConfig) }
                )
                Spacer()
            }
#else
            StatListView()
            ActionsView(
                shutdownEnabled: statService.shutdownEnabled,
                performShutdown: { statService.requestShutdown(config: hostConfig) },
                performRestart: { statService.requestRestart(config: hostConfig) }
            )
            Spacer()
#endif
        }.onAppear {
            requestInstantStats()
        }
        .onReceive(timer) { time in
            requestInstantStats()
        }
    }
    
    func requestInstantStats() {
        // This is run in the main thread
        statService.requestManyStatsInstant(
            stats: ["cpu", "memTotal", "memFree", "gpu", "throttled", "temp", "volts"],
            config: hostConfig
        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
                .navigationTitle("media.local")
                .environmentObject(StatService.shared)
                .environmentObject(HostServerConfig(host: "http://media.local", port: 4333))
        }
    }
}
