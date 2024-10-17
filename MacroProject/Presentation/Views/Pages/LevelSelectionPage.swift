//
//  LevelSelectionPage.swift
//  MacroProject
//
//  Created by Agfi on 12/10/24.
//

import SwiftUI
import Routing

struct LevelSelectionPage: View {
    @ObservedObject var levelViewModel: LevelViewModel = LevelViewModel()
    @ObservedObject var phraseViewModel: PhraseCardViewModel = PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository()))
    @Environment(\.presentationMode) var presentationMode
//    @Binding var selectedView: TabViewType
    @StateObject var router: Router<NavigationRoute>
    var level: Level
    
    init(router: Router<NavigationRoute>, level: Level) {
        _router = StateObject(wrappedValue: router)
        self.level = level
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if level.level == 1 {
                    Button(action: {
                        router.popToRoot()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        AddTopic()
                    }
                }
                ForEach(levelViewModel.topicsToReviewTodayFilteredByLevel) { topic in
                    Button(action: {
                        levelViewModel.showStudyConfirmation = true
                        levelViewModel.selectedTopicToReview = topic
                        levelViewModel.fetchPhraseCardsToReviewByTopic(levelNumber: String(level.level), topicID: topic.id)
                    }) {
                        TopicCardReview(topicDTO: topic)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            levelViewModel.fetchTopicsByFilteredPhraseCards(levelNumber: String(level.level), level: level)
            levelViewModel.setSelectedLevel(level: level)
        }
        .overlay(
            ZStack {
                if levelViewModel.showAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all) // Updated for SwiftUI compatibility
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showAlert, title: levelViewModel.alertTitle, message: levelViewModel.alertMessage, dismissAction: {
                        levelViewModel.resetAlert()
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                if levelViewModel.showStudyConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all) // Updated for SwiftUI compatibility
                    StartStudyAlert(levelViewModel: levelViewModel, phraseViewModel: phraseViewModel, router: router)
                }
            }
        )
        .navigationBarBackButtonHidden(levelViewModel.showAlert || levelViewModel.showStudyConfirmation)
    }
}

//#Preview {
//    ContentView()
//}
