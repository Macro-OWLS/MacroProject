import SwiftUI
import Routing

struct LevelSelectionPage: View {
    @EnvironmentObject var phraseViewModel: PhraseCardViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
//    @EnvironmentObject var topicStudyViewModel: TopicStudyViewModel
//    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var router: Router<NavigationRoute>
    @Binding var selectedView: TabViewType
    var level: Level
    
    init(router: Router<NavigationRoute>, selectedView: Binding<TabViewType>, level: Level) {
        _router = StateObject(wrappedValue: router)
        _selectedView = selectedView
        self.level = level
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.brown)
                .frame(height: 1)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if level.level == 1 {
                    Button(action: {
                        selectedView = .library
                        router.popToRoot()
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
                    }) {
                        TopicCardReview(topicDTO: topic, color: Color.brown)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .background(Color.cream)
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !levelViewModel.showAlert && !levelViewModel.showStudyConfirmation && !levelViewModel.showUnavailableAlert {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .fontWeight(.bold)
                            Text("Back")
                        }
                        .foregroundColor(.blue)
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
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showAlert, title: levelViewModel.alertTitle, message: levelViewModel.alertMessage, dismissAction: {
                        levelViewModel.resetAlert()
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                if levelViewModel.showStudyConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    StartStudyAlert(router: router)
                }
                if levelViewModel.showUnavailableAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showUnavailableAlert, title: "Daily Review Limit", message: "Cards can only be reviewed once a day.", dismissAction: {
                        levelViewModel.resetUnavailableAlert()
                    }))
                }
            }
        )
    }
}
