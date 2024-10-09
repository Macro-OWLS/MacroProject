//
//  ContentView.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData

enum TabViewType: String, CaseIterable {
    case study = "Study"
    case library = "Library"
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
                .tag(TabViewType.study)
            
            PhraseCardView(viewModel: phraseCardViewModel)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(TabViewType.library)
        }
    }
    
}

#Preview {
    ContentView()
}
