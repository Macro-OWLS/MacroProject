//
//  LevelPage.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import SwiftUI
import Routing

struct Level: Equatable, Hashable {
    let level: Int
    let title: String
    let description: String
}

struct LevelPage: View {
    @StateObject var levelViewModel: LevelViewModel = LevelViewModel()
    @StateObject var router: Router<NavigationRoute>
    @Binding var selectedTabView: TabViewType
    
    init(router: Router<NavigationRoute>, selectedTabView: Binding<TabViewType>) {
        _router = StateObject(wrappedValue: router)
        _selectedTabView = selectedTabView
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.0, green: 0.98, blue: 0.94) // Set the background color directly without extension
                    .ignoresSafeArea() // Make sure it covers the entire screen
                
                VStack {
                    // Line below the navigation bar
                    Rectangle()
                        .fill(Color.brown) // Stroke color
                        .frame(height: 1) // Line width
                    
                    // Spacing between the line and the ReviewBox
                    Spacer().frame(height: 32)
                    
                    ForEach(levelViewModel.levels, id: \.level) { level in
                        Button(action: {
                            router.routeTo(.levelSelectionPage(level, $selectedTabView))
                        }) {
                            ReviewBox(
                                level: level,
                                color: levelViewModel.setBackgroundColor(for: level),
                                strokeColor: levelViewModel.setStrokeColor(for: level)  // Pass stroke color here
                            )
                            .foregroundColor(levelViewModel.setTextColor(for: level))
                        }
                        .padding(.bottom, 8)
                        .padding(.horizontal, 16) // Add horizontal padding for the ReviewBox
                    }
                    Spacer()
                }
                .foregroundColor(.black)
            }
            .navigationTitle("Study Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(levelViewModel.formattedDate())
                        .font(.helveticaHeader3)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
