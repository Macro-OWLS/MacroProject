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
    @ObservedObject var phraseCardViewModel: PhraseCardViewModel
    @Binding var selectedView: TabViewType

    var body: some View {
        NavigationView {
            VStack {
                ForEach(levelViewModel.levels, id: \.level) { level in
                    NavigationLink(destination: LevelSelectionPage(levelViewModel: levelViewModel, phraseCardViewModel: phraseCardViewModel, level: level, selectedView: $selectedView)) {
                        ReviewBox(
                            level: level,
                            color: levelViewModel.setBackgroundColor(for: level)
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
        }
    }
}

#Preview {
    ContentView()
}
