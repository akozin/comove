//
//  StartButtonView.swift
//  Comove
//
//  Created by akozin on 14.09.2022.
//

import SwiftUI

struct StartButtonView: View {
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
                    Text("Start")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white),
                    alignment: .center
                )
        }
    }
}

struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartButtonView(action: {})
        }
    }
}
