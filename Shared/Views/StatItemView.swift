//
//  StatItem.swift
//  RaspStat
//
//  Created by Hanif Shersy on 22/3/2022.
//

import SwiftUI

#if os(macOS)
let HERO_HEIGHT: Int = 60
let EXPAND_ANIMATION_DURATION = 0.15
#else
let HERO_HEIGHT: Int = 80
let EXPAND_ANIMATION_DURATION = 0.15
#endif

struct StatInformation {
    var name: String
    var value: String
}

struct StatItemView: View {
    var name: String
    var mainStat: StatInformation
    var secondStat: StatInformation?
    var action: (() -> Void)?
    
    var hero: Bool = false
    
    @State var clicked: Bool = false
    
    var body: some View {
        GroupBox(label:
                    Text(name)
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
        ) {
            HStack(spacing: 1) {
                Text("\(mainStat.name): ")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                + Text(mainStat.value)
                Spacer()
                if let stat = secondStat {
                    Text("\(stat.name): ")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    + Text(stat.value)
                }
                Spacer()
#if os(macOS)
                Button(action: {
                    withAnimation(.easeOut(duration: EXPAND_ANIMATION_DURATION)) {
                        action?()
                        clicked.toggle()
                        
                    }
                }) { Text("View").fontWeight(.light) }
#endif
            }
            .frame(minHeight: hero ? CGFloat(clicked ? HERO_HEIGHT*2 : HERO_HEIGHT) : clicked ? CGFloat(HERO_HEIGHT) : .zero, alignment: clicked ? .top : .center)
#if os(macOS)
            .padding()
#endif
        }
        .animation(.easeOut(duration: EXPAND_ANIMATION_DURATION), value: clicked)
        .frame(maxWidth: .infinity, alignment: .top)
        .onTapGesture {
            withAnimation(.easeOut(duration: EXPAND_ANIMATION_DURATION)) {
                clicked.toggle()
            }
        }
#if !os(macOS)
        .border(hero ?
                LinearGradient(colors: [.red, .green], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)) :
                    LinearGradient(colors: [], startPoint: UnitPoint(), endPoint: UnitPoint())
        )
        .padding(.bottom, 4)
#endif
    }
}

struct StatItem_Previews: PreviewProvider {
    static var previews: some View {
        StatItemView(name: "CPU", mainStat: StatInformation(name: "Speed", value: "0.50 Ghz"), hero: true)
        StatItemView(name: "Memory", mainStat: StatInformation(name: "Total", value: "8.00 GB"))
    }
}
