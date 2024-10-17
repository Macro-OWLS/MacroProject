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
            .padding(.top, 32)
            .padding(.horizontal, 16)
            .navigationTitle("Study Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(levelViewModel.formattedDate())
                        .font(.helveticaHeader3)
                }
            }
            .background(Color.cream) // Apply background color to VStack
        }
    }
}

#Preview {
    ContentView()
}
