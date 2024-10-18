import SwiftUI
import Routing

struct LevelSelectionPage: View {
    @ObservedObject var levelViewModel: LevelViewModel = LevelViewModel()
    @ObservedObject var phraseViewModel: PhraseCardViewModel = PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository()))
    @Environment(\.presentationMode) var presentationMode
    @StateObject var router: Router<NavigationRoute>
    @Binding var selectedView: TabViewType
    var level: Level
    
    init(router: Router<NavigationRoute>, level: Level, selectedView: Binding<TabViewType>) {
        _router = StateObject(wrappedValue: router)
        self.level = level
        _selectedView = selectedView
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
                        selectedView = .library
                        router.popToRoot()
//                        presentationMode.wrappedValue.dismiss()
                    }) {
                        AddTopic()
                    }
                }

                ForEach(levelViewModel.availableTopicsToReview) { topic in
                    Button(action: {
                        levelViewModel.showStudyConfirmation = true
                        levelViewModel.selectedTopicToReview = topic
                        levelViewModel.fetchPhraseCardsToReviewByTopic(levelNumber: String(level.level), topicID: topic.id)
                    }) {
                        TopicCardReview(topicDTO: topic, color: Color.black)
                    }
                }
                
                ForEach(levelViewModel.unavailableTopicsToReview) { topic in
                    Button(action: {
                        levelViewModel.showUnavailableAlert = true
                        levelViewModel.printReviewDates(topic: topic)
                    }) {
                        TopicCardReview(topicDTO: topic, color: Color.brown)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            levelViewModel.setSelectedLevel(level: level)
            levelViewModel.checkDateForLevelAccess(level: level)
            levelViewModel.fetchTopicsByFilteredPhraseCards(levelNumber: String(level.level), level: level)
        }
        .overlay(
            ZStack {
                if levelViewModel.showStudyConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all) // Updated for SwiftUI compatibility
                    StartStudyAlert(levelViewModel: levelViewModel, phraseViewModel: phraseViewModel, router: router)
                }
                if levelViewModel.showUnavailableAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all)
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showUnavailableAlert, title: "Daily Review Limit", message: "Cards can only be reviewed once a day.", dismissAction: {
                        levelViewModel.resetUnavailableAlert()
                    }))
                }
            }
        )
        .navigationBarBackButtonHidden(levelViewModel.showAlert || levelViewModel.showStudyConfirmation)
    }
}
