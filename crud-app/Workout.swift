



/*
 name (String): The label or description of the training session (e.g., "Morning Run", "Squats").

 type (Enum): A strict classification matching WorkoutType (.weights or .cardio).

 duration (Double): A numeric property representing the total time spent training in minutes.

 date (Date): A timestamp tracking exactly when the activity took place.
*/

import Foundation

// Enum
enum WorkoutType: String, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
}

// Item Class (Pass by reference)
class Workout {
    //let id: UUID = UUID()
    
    var name: String         // String field
    var type: WorkoutType     // Enum field
    var duration: Double      // Number field (minutes)
    var date: Date            // Date field
    
    init(name: String, type: WorkoutType, duration: Double, date: Date) {
        self.name = name
        self.type = type
        self.duration = duration
        self.date = date
    }
}
