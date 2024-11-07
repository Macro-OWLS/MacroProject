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
    @StateObject private var libraryPhraseViewModel: LibraryPhraseCardViewModel = LibraryPhraseCardViewModel()
    @StateObject private var levelViewModel: LevelViewModel = LevelViewModel()
    @StateObject private var levelSelectionViewModel: LevelSelectionViewModel = LevelSelectionViewModel()
    @StateObject private var studyPhraseViewModel: StudyPhraseViewModel = StudyPhraseViewModel()
    @StateObject private var libraryViewModel: LibraryViewModel = LibraryViewModel()

    
    var body: some Scene {
        WindowGroup {
            RouterManagerView {
                ContentView()
            }
            .environmentObject(libraryPhraseViewModel)
            .environmentObject(levelViewModel)
            .environmentObject(levelSelectionViewModel)
            .environmentObject(studyPhraseViewModel)
            .environmentObject(libraryViewModel)
        }
    }
}
