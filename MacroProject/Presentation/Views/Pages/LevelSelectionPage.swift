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
            // Add the Rectangle under the navigation bar
            Rectangle()
                .fill(Color.brown) // Stroke color
                .frame(height: 1) // Line width
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if level.level == 1 {
                    Button(action: {
                        selectedView = .library
                        router.popToRoot()
                    }) {
                        AddTopic()
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
            }
            .padding() // Apply padding here
            Spacer()
        }
        .background(Color.cream) // Setting the background color to cream
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hides the native back button completely
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !levelViewModel.showAlert && !levelViewModel.showStudyConfirmation && !levelViewModel.showUnavailableAlert {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Custom back button action
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .fontWeight(.bold)
                            Text("Back")
                        }
                        .foregroundColor(.blue) // Set the color of the back button
                    }
                }
            }
        }
        .onAppear {
            levelViewModel.setSelectedLevel(level: level)
            levelViewModel.checkDateForLevelAccess(level: level)
            levelViewModel.fetchTopicsByFilteredPhraseCards(levelNumber: String(level.level), level: level)
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
                if levelViewModel.showUnavailableAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all)
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showUnavailableAlert, title: "Daily Review Limit", message: "Cards can only be reviewed once a day.", dismissAction: {
                        levelViewModel.resetUnavailableAlert()
                    }))
                }
            }
        )
    }
}
