//
//  LevelPage.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import SwiftUI
import Routing

struct Level {
    let level: Int
    let title: String
    let description: String
}

struct LevelPage: View {
    @StateObject var levelViewModel: LevelViewModel = LevelViewModel()
    @Binding var selectedView: TabViewType

    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Use spacing of 0 to prevent extra space between views
                
                // Main content stack
                VStack {
                    ForEach(levelViewModel.levels, id: \.level) { level in
                        NavigationLink(destination: LevelSelectionPage(levelViewModel: levelViewModel, level: level, selectedView: $selectedView)) {
                            ReviewBox(
                                level: level,
                                color: levelViewModel.setBackgroundColor(for: level),
                                strokeColor: levelViewModel.setStrokeColor(for: level)  // Correctly pass stroke color here
                            )
                            .foregroundColor(levelViewModel.setTextColor(for: level))
                        }
                        .padding(.bottom, 8)
                    }
                    Spacer()
                }
                .foregroundColor(.black)
                .padding(.top, 16) // Adjust as needed for spacing
            }
            .background(Color.cream)
            
            .navigationTitle("Study Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem (placement: .topBarLeading){
                    Text(DateHelper.formattedDateString())
                        .font(.helveticaHeader3)
                }
            }

        }
    }
}

#Preview {
    ContentView()
}

