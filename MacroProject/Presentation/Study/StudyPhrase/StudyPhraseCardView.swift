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
                } else if !phraseViewModel.showUnavailableAlert {
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
                            AddCard(isDisabled: phraseViewModel.checkIfCardSelected())
                        }
                        .buttonStyle(.plain)
                        .frame(width: 225, height: 50, alignment: .center)
                        .disabled(phraseViewModel.checkIfCardSelected())
                    }
                    .padding(.bottom, 105)
   

                }
            }
            .navigationTitle(topicViewModel.topics.first { $0.id == topicID }?.name ?? "Unknown Topic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if !phraseViewModel.showUnavailableAlert {
                        Button("Done") {
                            Task {
                                await phraseViewModel.savePhraseToRemoteProfile()
                            }
                            router.navigateBack()
                        }
                        .foregroundColor(Color.red)
                        .bold()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                topicViewModel.fetchTopics()
                phraseViewModel.fetchPhraseCards(topicID: topicID)
                phraseViewModel.resetCardsAdded()
                phraseViewModel.checkIfEmpty()
            }
            .onChange(of: phraseViewModel.phraseCards) { newValue in
                if phraseViewModel.phraseCards.isEmpty {
                    phraseViewModel.showUnavailableAlert = true
                } else {
                    phraseViewModel.showUnavailableAlert = false
                }
            }
            
            if phraseViewModel.showUnavailableAlert {
                Color.black.opacity(0.4).ignoresSafeArea(edges: .all)
                AlertView(alert: AlertType(
                    isPresented: .constant(showUnavailableAlert),
                    title: "Deck is Empty",
                    message: "Choose another topic to review.",
                    dismissAction: {
                        router.navigateBack()
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
