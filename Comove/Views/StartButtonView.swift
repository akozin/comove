//
//  StartButtonView.swift
//  Comove
//
//  Created by akozin on 14.09.2022.
//

import SwiftUI

struct StartButtonView: View {
    var label: String
    let action: () -> Void
    
    private var primaryColor: Color {
        let color = UIColor(named: "PrimaryColor") ?? .systemBlue
        return Color(color)
    }
    
    var body: some View {
        Button(action: action) {
            Circle()
                .frame(width: 80, height: 80, alignment: .center)
                .foregroundColor(primaryColor)
                .overlay(
                    Text(LocalizedStringKey(label))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                        .padding(5),
                    alignment: .center
                )
        }
    }
}

struct StartButtonView_Previews: PreviewProvider {
    static var label: String = "Stop"
    static var previews: some View {
        Group {
            StartButtonView(label: label, action: {})
        }
    }
}
