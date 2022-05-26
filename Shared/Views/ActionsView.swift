//
//  ActionsView.swift
//  RaspStat
//
//  Created by Hanif Shersy on 26/5/2022.
//

import SwiftUI


struct ActionsView: View {
    typealias Action = (() -> ())?
    var shutdownEnabled: Bool

    var performShutdown: Action = nil
    var performRestart: Action = nil
    var selectedAction: Action = nil

    @State var showUnsafeOperationWarning: (Bool, Action) = (false, nil)
    var body: some View {
        VStack {
            Group {
                RoundedButton(title: "Shutdown", bolded: true) {
                    showUnsafeOperationWarning = (true, self.performShutdown)
                }
                RoundedButton(title: "Restart", bolded: false) {
                    showUnsafeOperationWarning = (true, self.performShutdown)
                }
            }
            .disabled(!shutdownEnabled)
            .foregroundColor(shutdownEnabled ? .blue : .gray)
        }.padding()
            .actionSheet(isPresented: self.$showUnsafeOperationWarning.0) {
                ActionSheet(
                    title: Text("Are you sure you want to shutdown the device?\nThe stat-monitoring server will be turned off."),
                    buttons: [
                        .destructive(Text("Continue")) { self.showUnsafeOperationWarning.1?() },
                        .cancel() {  self.showUnsafeOperationWarning = (false, nil) }
                    ]
                )
            }
        
    }
}

struct ActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView(shutdownEnabled: true, showUnsafeOperationWarning: (true, nil))
    }
}
