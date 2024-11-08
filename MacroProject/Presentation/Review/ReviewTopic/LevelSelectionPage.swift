import SwiftUI
 

struct LevelSelectionPage: View {
    @EnvironmentObject var levelViewModel: LevelSelectionViewModel
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode
    var level: Level
    
    init(level: Level) {
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
                        router.popToRoot()
                    }) {
                        AddTopic()
                    }
                }
                
                ForEach(levelViewModel.topicsToReviewToday) { topic in
                    Button(action: {
                        if topic.isDisabled {
                            levelViewModel.showUnavailableAlert = true
                        } else {
                            levelViewModel.showReviewConfirmation = true
                            reviewPhraseViewModel.selectedTopicToReview = topic
                        }
                    }) {
                        TopicCardReview(topicDTO: topic, color: topic.isDisabled ? Color.brown : Color.black)
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
                if !levelViewModel.showAlert && !levelViewModel.showReviewConfirmation && !levelViewModel.showUnavailableAlert {
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
            levelViewModel.fetchPhrasesToReviewTodayFilteredByLevel(selectedLevel: level)
            levelViewModel.selectedLevel = level
        }
        .overlay(
            ZStack {
                if levelViewModel.showAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showAlert, title: levelViewModel.alertTitle, message: levelViewModel.alertMessage, dismissAction: {
                        levelViewModel.showAlert = false
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                if levelViewModel.showReviewConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    StartReviewAlert()
                }
                if levelViewModel.showUnavailableAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showUnavailableAlert, title: "Daily Review Limit", message: "Cards can only be reviewed once a day.", dismissAction: {
                        levelViewModel.showUnavailableAlert = false
                    }))
                }
            }
        )
    }
}
