//
//  StatListView.swift
//  RaspStat
//
//  Created by Hanif Shersy on 28/3/2022.
//

import SwiftUI

struct StatListView: View {
    @EnvironmentObject var statService: StatService
    
    func data() {
        
    }
    var body: some View {
        StatItemView(
            name: "CPU",
            mainStat: StatInformation(
                name: "Speed",
                value: statService.cpuStat
            ),
            secondStat: StatInformation(
                name: "Throttled",
                value: statService.throttledStat
            ),
            hero: true
        )
        StatItemView(
            name: "Memory",
            mainStat: StatInformation(
                name: "Free",
                value: "\(statService.memFreeStat)"
            ),
            secondStat: StatInformation(
                name: "Total",
                value: "\(statService.memTotalStat)"
            )
        )
        StatItemView(
            name: "GPU",
            mainStat: StatInformation(
                name: "Speed",
                value: statService.gpuStat
            )
        )
        StatItemView(
            name: "SoC",
            mainStat: StatInformation(
                name: "Temperature",
                value: "\(statService.tempStat)"
            ),
            secondStat: StatInformation(
                name: "Volts",
                value: "\(statService.voltsStat)"
            )
        )
    }
}

struct StatListView_Previews: PreviewProvider {
    static var previews: some View {
        StatListView()
            .environmentObject(StatService.shared)
    }
}
