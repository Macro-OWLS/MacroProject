import SwiftUI

struct StudyPhraseCardView: View {
    @EnvironmentObject var topicViewModel: StudyViewModel
    @EnvironmentObject var phraseViewModel: StudyPhraseCardViewModel
    @EnvironmentObject var router: Router
    var topicID: String
    
    @State private var showUnavailableAlert = false
    
    init(topicID: String) {
        self.topicID = topicID
    }
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if phraseViewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = phraseViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    Text("Cards Added: \(phraseViewModel.cardsAdded)")
                        .font(.poppinsH3)
                        .padding(27)
                    
                    SwipeableFlashcardsView()
                        .padding(.bottom, 129)
                        .environmentObject(phraseViewModel)
                }
            }
            .navigationTitle(topicViewModel.topics.first { $0.id == topicID }?.name ?? "Unknown Topic")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !showUnavailableAlert {
                        Button("Done") {
                            router.popToRoot()
                        }
                        .foregroundColor(Color.blue)
                    }
                }
            }
            
            .onAppear {
                print("vieww")
                topicViewModel.fetchTopics()
                phraseViewModel.fetchPhraseCards(topicID: topicID)
                phraseViewModel.resetCardsAdded()
            }
            
            if showUnavailableAlert {
                Color.black.opacity(0.4).ignoresSafeArea(edges: .all)
                AlertView(alert: AlertType(
                    isPresented: .constant(showUnavailableAlert),
                    title: "Deck is Empty",
                    message: "Choose another topic to review.",
                    dismissAction: {
                        router.popToRoot()
                    }
                ))
            }
        }
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.brown)
                    .frame(height: 1)
            },
            alignment: .top
        )
    }
}

#Preview {
    StudyPhraseCardView(topicID: "T1")
        .environmentObject(StudyViewModel())
        .environmentObject(StudyPhraseCardViewModel())
}
