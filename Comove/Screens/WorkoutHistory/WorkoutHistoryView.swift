//
//  WorkoutHistoryView.swift
//  Comove
//
//  Created by akozin on 04.10.2022.
//

import SwiftUI
import CoreLocation

struct WorkoutHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: WorkoutHistoryViewModel.fetchRequest, animation: .default)
    private var workoutList: FetchedResults<WorkoutEntity>
    
    private let viewModel = WorkoutHistoryViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(workoutList) { workout in
                    let date = viewModel.formatDate(workout.timestamp)
                    let duration = viewModel.formatDuration(workout.duration)
                    let distance = viewModel.formatDistance(workout.distance)
                    HStack {
                        Text("Date: \(date)")
                        Text("Duration: \(duration)")
                        Text("Distance: \(distance)")
                    }
                }
            }
            .navigationTitle("workout_history_title")
        }
    }
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
