//
//  MacroProjectApp.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
  }
}

@main
struct MacroProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject private var levelViewModel: LevelViewModel = LevelViewModel()
    @StateObject private var levelSelectionViewModel: LevelSelectionViewModel = LevelSelectionViewModel()
    @StateObject private var studyViewModel: StudyViewModel = StudyViewModel()
    @StateObject private var studyPhraseViewModel: StudyPhraseCardViewModel = StudyPhraseCardViewModel()
    @StateObject private var reviewPhraseViewModel = ReviewPhraseViewModel()

    
    var body: some Scene {
        WindowGroup {
            RouterManagerView {
                ContentView()
            }
            .environmentObject(homeViewModel)
            .environmentObject(levelViewModel)
            .environmentObject(levelSelectionViewModel)
            .environmentObject(studyViewModel)
            .environmentObject(onboardingViewModel)
            .environmentObject(studyPhraseViewModel)
            .environmentObject(reviewPhraseViewModel)
        }
    }
}
