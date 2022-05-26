//
//  RaspStatApp.swift
//  Shared
//
//  Created by Hanif Shersy on 16/3/2022.
//

import SwiftUI

@main
struct RaspStatApp: App {
    
    private var statService = StatService.shared
    private var hostConfig = HostServerConfig(host: "http://media.local", port: 4333) // TODO: temporary
    
    var body: some Scene {
        
        WindowGroup {
#if os(macOS)
//            HSplitView {
//                VStack {
//                    List {
                        
//                        Button( action:{  }, label: { Text("Pi Stats") })
//                        /*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
//                        /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
//                        /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
//                    }
//                }
                
                ContentView()
//                    .frame(minWidth: 290) // SplitView
                    .frame(minWidth: 310, idealHeight: 150)
                    .padding(.horizontal)
                    .environmentObject(statService)
                    .environmentObject(hostConfig)
                
                
//            }
//            .frame(maxHeight: 450)
#else
            NavigationView {
                ScrollView {
                    ContentView()
                        .environmentObject(statService)
                        .environmentObject(hostConfig)
                        .padding()
                }
                .navigationTitle("media.local")
            }
#endif
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
#endif
    }
}
