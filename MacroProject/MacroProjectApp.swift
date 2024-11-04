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
    @StateObject private var newLevelViewModel: NewLevelViewModel = NewLevelViewModel()
    @StateObject private var levelSelectionViewModel: LevelSelectionViewModel = LevelSelectionViewModel()
    @StateObject private var newLevelSelectionViewModel: NewLevelSelectionViewModel = NewLevelSelectionViewModel()
    @StateObject private var studyPhraseViewModel: StudyPhraseViewModel = StudyPhraseViewModel()
    @StateObject private var libraryViewModel = LibraryViewModel(topicViewModel: TopicViewModel())

    
    var body: some Scene {
        WindowGroup {
            RouterManagerView {
                ContentView()
            }
            .environmentObject(topicLibraryViewModel)
            .environmentObject(phraseLibraryCardViewModel)
            .environmentObject(levelViewModel)
            .environmentObject(newLevelViewModel)
            .environmentObject(levelSelectionViewModel)
            .environmentObject(newLevelSelectionViewModel)
            .environmentObject(studyPhraseViewModel)
            .environmentObject(libraryViewModel)
        }
    }
}
