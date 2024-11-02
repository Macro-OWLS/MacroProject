import SwiftUI
 

struct LevelSelectionPage: View {
    @EnvironmentObject var levelViewModel: NewLevelSelectionViewModel
    @EnvironmentObject var studyPhraseViewModel: StudyPhraseViewModel
    @EnvironmentObject var router: Router
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
                
                ForEach(levelViewModel.topicsToReviewToday) { topic in
                    Button(action: {
                        if topic.isDisabled {
                            levelViewModel.showUnavailableAlert = true
                        } else {
                            levelViewModel.showStudyConfirmation = true
                            studyPhraseViewModel.selectedTopicToReview = topic
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
                if levelViewModel.showStudyConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    StartStudyAlert()
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
