//
//  MacroProjectApp.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData

@main
struct MacroProjectApp: App {
    @StateObject private var topicLibraryViewModel: TopicViewModel = TopicViewModel()
    @StateObject private var phraseLibraryCardViewModel: PhraseCardViewModel = PhraseCardViewModel()
    @StateObject private var levelViewModel: LevelViewModel = LevelViewModel()
//    @StateObject private var phraseStudyViewModel: PhraseStudyViewModel = PhraseStudyViewModel()
//    @StateObject private var topicStudyViewModel: TopicStudyViewModel = TopicStudyViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(topicLibraryViewModel)
                .environmentObject(phraseLibraryCardViewModel)
                .environmentObject(levelViewModel)
//                .environmentObject(phraseStudyViewModel)
//                .environmentObject(topicStudyViewModel)
        }
    }
}
