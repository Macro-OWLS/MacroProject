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
    @State private var selectedView: TabViewType = .study
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some View {
        TabView(selection: $selectedView) {
            LevelPage()
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
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(Color.cream)
        let itemAppearance = UITabBarItemAppearance()
        
        // Set the color for unselected items
        itemAppearance.normal.iconColor = UIColor.black
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // Set the color for selected items
        itemAppearance.selected.iconColor = UIColor(Color.turquoise)
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.turquoise)]
        
        // Apply the item appearance to the tab bar appearance
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        
        // Apply the appearance to both standard and scroll edge appearances (iOS 15+)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

#Preview {
    ContentView()
}
