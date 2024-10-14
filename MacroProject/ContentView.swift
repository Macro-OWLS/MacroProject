//
//  ContentView.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData
import Routing

enum TabViewType: String, CaseIterable {
    case study = "Study"
    case library = "Library"
}

struct ContentView: View {
    @StateObject private var topicViewModel: TopicViewModel = TopicViewModel(useCase: TopicUseCase(repository: TopicRepository()))
    @StateObject private var phraseCardViewModel: PhraseCardViewModel = PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository()))
    @State private var selectedView: TabViewType = .library
    
    var body: some View {
        NavigationStack {
            RoutingView(NavigationRoute.self) { router in
                TabView(selection: $selectedView) {
                    LibraryPhraseCardView(viewModel: phraseCardViewModel, topicViewModel: topicViewModel,router: router, topicID: "T1")
                        .tabItem {
                            Label("Study", systemImage: "book.pages.fill")
                        }
                        .tag(TabViewType.study)
                    
                    LibraryView(router: router, viewModel: topicViewModel)
                        .tabItem {
                            Label("Library", systemImage: "books.vertical.fill")
                        }
                        .tag(TabViewType.library)
                }
            }
        }

    }
    
}

#Preview {
    ContentView()
}
