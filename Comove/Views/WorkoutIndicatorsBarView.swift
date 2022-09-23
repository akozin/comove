//
//  WorkoutIndicatorsBarView.swift
//  Comove
//
//  Created by akozin on 15.09.2022.
//

import SwiftUI

struct WorkoutIndicatorsBarView: View {
    var speed: String
    var distance: String
    var pace: String
    var duration: String
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    VStack {
                        Text("Speed")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(speed)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("Dist.")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(distance)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("Pace")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(pace)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("Dur.")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(duration)
                            .bold()
                    }
                }
                .padding(.all)
            }
            .frame(width: proxy.size.width, height: 100,
                   alignment: .center)
            .background(
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.85),
                alignment: .center
            )
        }
    }
}

struct WorkoutIndicatorsBarView_Previews: PreviewProvider {
    static var speed = "10 km/h"
    static var distance = "1.2 km"
    static var pace = "6 min/km"
    static var duration = "1h 20min"
    static var previews: some View {
        Group {
            WorkoutIndicatorsBarView(speed: speed,
                                     distance: distance,
                                     pace: pace,
                                     duration: duration)
            WorkoutIndicatorsBarView(speed: speed,
                                     distance: distance,
                                     pace: pace,
                                     duration: duration)
            .previewDevice("iPhone SE (1st generation)")
        }
    }
}
