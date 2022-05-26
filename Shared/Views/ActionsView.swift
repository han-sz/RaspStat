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
#if os(iOS)
                    showUnsafeOperationWarning = (true, self.performShutdown)
#else
                    self.performShutdown?()
#endif
                }
                RoundedButton(title: "Restart", bolded: false) {
#if os(iOS)
                    showUnsafeOperationWarning = (true, self.performRestart)
#else
                    self.performRestart?()
#endif
                }
            }
            .disabled(!shutdownEnabled)
            .foregroundColor(shutdownEnabled ? .black : .gray)
        }.padding()
        #if os(iOS)
            .actionSheet(isPresented: self.$showUnsafeOperationWarning.0) {
                ActionSheet(
                    title: Text("Are you sure you want to shutdown the device?\nThe stat-monitoring server will be turned off."),
                    buttons: [
                        .destructive(Text("Continue")) { self.showUnsafeOperationWarning.1?() },
                        .cancel() {  self.showUnsafeOperationWarning = (false, nil) }
                    ]
                )
            }
        #endif
        
    }
}

struct ActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView(shutdownEnabled: true, showUnsafeOperationWarning: (true, nil))
    }
}
