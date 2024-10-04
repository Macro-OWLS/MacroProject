//
//  ReviewBox.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 01/10/24.
//

import SwiftUI

struct ReviewBox: View {
    let labels = ["1st", "2nd", "3rd", "4th", "5th"]
    @State private var selectedLabel: String = "1st"
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 16) {
                ForEach(labels, id: \.self) { label in
                    Button(action: {
                        selectedLabel = label
                    }) {
                        Text(label)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(isAccessible(label: label) ? (selectedLabel == label ? .white : .black) : .gray)
                            .multilineTextAlignment(.center)
                            .frame(width: 57, height: 42)
                            .background(isAccessible(label: label) ? (selectedLabel == label ? Color.gray : Color.gray.opacity(0.3)) : Color.gray.opacity(0.1)) // Lighter gray for inaccessible
                            .cornerRadius(15)
                    }
                }
            }
            
            TabView(selection: $selectedLabel) {
                ForEach(labels, id: \.self) { label in
                    DetailView(label: label)
                        .tag(label)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 200) // Adjust the height of the sliding view
        }
        .padding()
    }
    
    // Function to check if a box is accessible based on the current day
    func isAccessible(label: String) -> Bool {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) // 1 for Sunday, 2 for Monday, etc.
        let currentWeek = calendar.component(.weekOfYear, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        
        switch label {
        case "1st":
            return true // Accessible every day
        case "2nd":
            return today == 3 || today == 5 // Tuesday and Thursday (3 = Tuesday, 5 = Thursday)
        case "3rd":
            return today == 6 // Friday
        case "4th":
            return today == 6 && currentWeek % 2 == 0 // Bi-weekly on Friday
        case "5th":
            return today == 6 && (currentDay <= 7 || (currentDay > 21 && currentDay <= 28)) // Once a month on the first or last Friday
        default:
            return false
        }
    }
}

struct DetailView: View {
    let label: String
    
    var body: some View {
        Text("Box \(label)")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    ReviewBox()
}
