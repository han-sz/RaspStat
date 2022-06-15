//
//  RaspStatApp.swift
//  Shared
//
//  Created by Hanif Shersy on 16/3/2022.
//

import SwiftUI

@main
struct RaspStatApp: App {
    
    // App Settings
    @AppStorage(SettingsKey.hostAddress.rawValue) private var hostAddress: String?
    @AppStorage(SettingsKey.hostPort.rawValue) private var hostPort: String?
    
    private var statService = StatService.shared
    private var hostConfig: HostServerConfig {
        generateDefaultHostConfig()
    }
    
    var body: some Scene {
#if os(macOS)
        Settings {
            TabView {
                SettingsView()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
            }
            .padding(20)
            .frame(width: 380, height: 250, alignment: .topLeading)
        }
#endif
        WindowGroup {
#if os(macOS)
            ContentView()
                .frame(minWidth: 330, idealWidth: 330, maxWidth: 470, idealHeight: 150)
                .padding(.horizontal)
                .environmentObject(statService)
                .environmentObject(hostConfig)
                .navigationTitle(hostConfig.host)
#else
            NavigationView {
                ScrollView {
                    ContentView()
                        .environmentObject(statService)
                        .environmentObject(hostConfig)
                        .padding()
                }
                .navigationTitle(hostConfig.host)
            }
#endif
        }
#if os(macOS)
        .commands {
            CommandGroup(replacing: .newItem, addition: { })
            CommandMenu("Actions") {
                Button("Shutdown") { statService.requestShutdown(config: hostConfig)}
                Button("Restart") { statService.requestRestart(config: hostConfig) }
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
#endif
    }
    
    private func generateDefaultHostConfig() -> HostServerConfig {
        return HostServerConfig(host: hostAddress ?? "media.local", port: Int(hostPort ?? "4333") ?? 4333)
    }
    
}
