import SwiftUI

struct LevelSelectionPage: View {
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
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
        VStack (spacing: 32){
            if levelSelectionViewModel.isLoading {
                LoadingView()
            } else {
                ScrollView(content: {
                    VStack (alignment: .leading, spacing: 8){
                        Text("Phase \(level.level)")
                            .font(.poppinsH1)
                        Text("\(level.description)")
                            .font(.poppinsB2)
                    }
                    .padding(.leading, 38)
                    .padding(.trailing, 42)
                    .padding(0)
                    .frame(width: 393, height: 0, alignment: .topLeading)
                    .padding(.bottom, 32)
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        if level.level == 1 {
                            Button(action: {
                                router.navigateTo(.studyView)
                            }) {
                                AddTopic()
                            }
                        }
                        
                        ForEach(levelSelectionViewModel.topicsToReviewToday) { topic in
                            Button(action: {
                                if topic.isDisabled {
                                    levelSelectionViewModel.showUnavailableAlert = true
                                } else {
                                    levelSelectionViewModel.showReviewConfirmation = true
                                    reviewPhraseViewModel.selectedTopicToReview = topic
                                }
                            }) {
                                TopicCardReview(topicDTO: topic, color: topic.isDisabled ? Color.brown : Color.black)
                            }
                        }
                    }
                    .padding(.top, 52)
                    .padding()
                })
            }
        }
        .background(Color.cream)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !levelSelectionViewModel.showAlert && !levelSelectionViewModel.showReviewConfirmation && !levelSelectionViewModel.showUnavailableAlert {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            levelSelectionViewModel.checkForAlerts(level: level)
            levelSelectionViewModel.emptyAlerts(level: level)
            levelSelectionViewModel.fetchPhrasesToReviewTodayFilteredByLevel(selectedLevel: level)
            levelSelectionViewModel.selectedLevel = level
        }
        .overlay(
            ZStack {
                
                if levelSelectionViewModel.showAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelSelectionViewModel.showAlert, title: levelSelectionViewModel.alertTitle, message: levelSelectionViewModel.alertMessage, dismissAction: {
                        levelSelectionViewModel.showAlert = false
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                if levelSelectionViewModel.showReviewConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    StartReviewAlert()
                }
                if levelSelectionViewModel.showUnavailableAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    AlertView(alert: AlertType(isPresented: $levelSelectionViewModel.showUnavailableAlert, title: "Daily Review Limit", message: "Cards can only be reviewed once a day.", dismissAction: {
                        levelSelectionViewModel.showUnavailableAlert = false
                    }))
                }
            }
        )
    }
}

#Preview {
    LevelSelectionPage(level: Level(level: 1, title: "Test", description: "Tes"))
        .environmentObject(LevelSelectionViewModel())
        .environmentObject(ReviewPhraseViewModel())
}
