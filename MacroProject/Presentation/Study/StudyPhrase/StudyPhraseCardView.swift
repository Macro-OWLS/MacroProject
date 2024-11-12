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
                    AssetContainer(capybaraImage: topicViewModel.topics.first { $0.id == topicID }?.icon ?? "")
                        .padding(.top, 50)
                        .padding(.trailing, 60)
                    StudyCarouselAnimation()
                        .padding(.bottom, 50)
                        .environmentObject(phraseViewModel)
                    VStack (spacing: 12){
                        Text("Cards Added: \(phraseViewModel.cardsAdded)")
                            .font(.poppinsB1)
                        
                        Button {
                            phraseViewModel.selectCard()
                            phraseViewModel.cardsAdded += 1
                        } label: {
                            ZStack{
                                Color.green
                                Text("Add Cards")
                                    .font(.poppinsB1)
                                    .foregroundStyle(Color.lightgrey)
                            }
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 225, height: 50, alignment: .center)
                    }
                    .padding(.bottom, 105)
   

                }
            }
            .navigationTitle(topicViewModel.topics.first { $0.id == topicID }?.name ?? "Unknown Topic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !showUnavailableAlert {
                        Button("Done") {
                            Task {
                                await phraseViewModel.savePhraseToRemoteProfile()
                            }
                            router.popToRoot()
                        }
                        .foregroundColor(Color.red)
                        .bold()
                    }
                }
            }
            .onAppear {
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
        .accentColor(Color.red)
    }
}


#Preview {
    StudyPhraseCardView(topicID: "T1")
        .environmentObject(StudyViewModel())
        .environmentObject(StudyPhraseCardViewModel())
}
