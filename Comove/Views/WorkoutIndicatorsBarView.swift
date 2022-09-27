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
        VStack {
            VStack {
                Text(duration)
                    .font(.largeTitle)
                    .bold()
                Text("Duration")
                    .font(.title3)
            }
            .padding(.bottom)
            
            HStack {
                VStack {
                    Text(distance)
                        .bold()
                        .padding(.bottom, 1)
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text(pace)
                        .bold()
                        .padding(.bottom, 1)
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text(speed)
                        .bold()
                        .padding(.bottom, 1)
                    Text("Speed")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .background(
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.85),
            alignment: .center
        )
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
//            WorkoutIndicatorsBarView(speed: speed,
//                                     distance: distance,
//                                     pace: pace,
//                                     duration: duration)
//            .previewDevice("iPhone SE (1st generation)")
        }
    }
}
