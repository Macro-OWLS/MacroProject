//
//  ContentView.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData

enum TabViewType: String, CaseIterable {
    case library = "Study"
    case study = "Library"
}

struct ContentView: View {
    @StateObject private var topicViewModel: TopicViewModel = TopicViewModel(useCase: TopicUseCase(repository: TopicRepository()))
    @StateObject private var phraseCardViewModel: PhraseCardViewModel = PhraseCardViewModel(useCase: PhraseCardUseCase())
    @State private var selectedView: TabViewType = .library
    
    var body: some View {
        TabView(selection: $selectedView) {
            TopicListView(viewModel: topicViewModel)
                .tabItem {
                    Label("Study", systemImage: "book.pages.fill")
                }
                .tag(TabViewType.library)
            
            PhraseCardView(viewModel: phraseCardViewModel)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(TabViewType.study)
        }
    }
}

#Preview {
    ContentView()
}
