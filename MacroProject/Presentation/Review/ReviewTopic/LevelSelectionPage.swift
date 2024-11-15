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
        VStack (spacing: 32){
            
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
                    
                    ForEach(levelViewModel.topicsToReviewToday) { topic in
                        if topic.phraseCardCount != 0 {
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
                }
                .padding(.top, 52)
                .padding()
            })
        }
        .background(Color.cream)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !levelViewModel.showAlert && !levelViewModel.showReviewConfirmation && !levelViewModel.showUnavailableAlert {
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

#Preview {
    LevelSelectionPage(level: Level(level: 1, title: "Test", description: "Tes"))
        .environmentObject(LevelSelectionViewModel())
        .environmentObject(ReviewPhraseViewModel())
}
