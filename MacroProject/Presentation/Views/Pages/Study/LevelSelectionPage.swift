import SwiftUI
 

struct LevelSelectionPage: View {
    @EnvironmentObject var phraseViewModel: PhraseCardViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var router: Router
//    @EnvironmentObject var topicStudyViewModel: TopicStudyViewModel
//    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedView: TabViewType
    var level: Level
    
    init(selectedView: Binding<TabViewType>, level: Level) {
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
            levelViewModel.checkDateForLevelAccess(level: level)
            levelViewModel.fetchTodayPhrases(level: String(level.level))
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
                    StartStudyAlert()
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
