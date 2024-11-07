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
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject private var levelViewModel: LevelViewModel = LevelViewModel()
    @StateObject private var levelSelectionViewModel: LevelSelectionViewModel = LevelSelectionViewModel()
    @StateObject private var studyPhraseViewModel: StudyPhraseViewModel = StudyPhraseViewModel()
    @StateObject private var libraryTopicViewModel: LibraryViewModel = LibraryViewModel()
    @StateObject private var libraryPhraseViewModel: LibraryPhraseCardViewModel = LibraryPhraseCardViewModel()

    
    var body: some Scene {
        WindowGroup {
            RouterManagerView {
                ContentView()
            }
            .environmentObject(homeViewModel)
            .environmentObject(levelViewModel)
            .environmentObject(levelSelectionViewModel)
            .environmentObject(studyPhraseViewModel)
            .environmentObject(libraryTopicViewModel)
            .environmentObject(libraryPhraseViewModel)
            .environmentObject(onboardingViewModel)
        }
    }
}
