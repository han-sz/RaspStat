//
//  RoundedButton.swift
//  RaspStat
//
//  Created by Hanif Shersy on 26/5/2022.
//

import SwiftUI

struct RoundedButton : View {
    var title: String
    var bolded: Bool? = false
    var onTap: (() -> ())?
    var body: some View {
        Button(action: { self.onTap?()  }) {
            Text(title)
                .font(bolded ?? false ? .headline : .body)
                .padding(.all, 16)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(title: "Shutdown", bolded: true)
    }
}
