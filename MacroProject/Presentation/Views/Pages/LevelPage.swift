//
//  LevelPage.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import SwiftUI
import Routing

struct Level: Equatable, Hashable {
struct Level: Equatable, Hashable {
    let level: Int
    let title: String
    let description: String
}

struct LevelPage: View {
    @StateObject var levelViewModel: LevelViewModel = LevelViewModel()
    @StateObject var router: Router<NavigationRoute>
    
    init(router: Router<NavigationRoute>) {
        _router = StateObject(wrappedValue: router)
    }
    
    @StateObject var router: Router<NavigationRoute>
    
    init(router: Router<NavigationRoute>) {
        _router = StateObject(wrappedValue: router)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(levelViewModel.levels, id: \.level) { level in
                    
                    Button(action: {
                        router.routeTo(.levelSelectionPage(level))
                    }) {
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
//
//#Preview {
//    ContentView()
//}
