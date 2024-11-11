import SwiftUI


struct ReviewPhraseView: View {
    @EnvironmentObject var phraseStudyViewModel: StudyPhraseCardViewModel
    @EnvironmentObject var reviewViewModel: ReviewPhraseViewModel
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
    @EnvironmentObject var router: Router

    @State private var isCorrect: Bool? = nil

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            VStack(spacing: 40) {
                VStack(spacing: 16, content: {
                    Text("\(reviewViewModel.unansweredPhrasesCount) Card(s) left")
                        .font(.poppinsHd)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(.bold)

                    CarouselAnimation()
                })

                VStack(spacing: 16) {
                    HStack(alignment: .center, spacing: 0, content: {
                        Text("")
                        Spacer()
                        Text(reviewViewModel.userInput)
                            .textCase(.uppercase)
                            .font(.poppinsH3)
                            .kerning(2)
                            .fontWeight(.medium)
                            .frame(width: 200, alignment: .leading)
                        Spacer()
                        Button(action: {
                            if !reviewViewModel.userInput.isEmpty {
                                let lastLetter = reviewViewModel.userInput.removeLast()
                                if let lastUsedIndex = reviewViewModel.shuffledLetters.first(where: { $0.letter.first == lastLetter && reviewViewModel.usedIndices.contains($0.index) })?.index {
                                    reviewViewModel.usedIndices.remove(lastUsedIndex)
                                }
                            }
                        }) {
                            Image(systemName: "delete.backward.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 36)
                        }
                    })
                    .frame(width: 352)

                    ScrabbleComponent(currentCard: reviewViewModel.currentCard)
                        .padding(.bottom, 25-15)

                    ZStack {
                        Rectangle()
                            .fill(reviewViewModel.userInput.isEmpty ? Color.gray : Color.green)
                            .frame(width: 90, height: 50, alignment: .leading)
                            .cornerRadius(12)

                        Text("Check")
                            .font(.poppinsB1)
                            .foregroundColor(Color.white)
                            .opacity(reviewViewModel.userInput.isEmpty ? 0.5 : 1)
                    }
                    .onTapGesture {
                        if let currentCard = reviewViewModel.currentCard, !reviewViewModel.userInput.isEmpty {
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: reviewViewModel.userInput, correctAnswer: currentCard.vocabulary)
                            reviewViewModel.isRevealed = true
                            reviewViewModel.addUserAnswer(userAnswer: UserAnswerDTO(id: String(reviewViewModel.currIndex), topicID: currentCard.topicID, vocabulary: currentCard.vocabulary, phrase: currentCard.phrase, translation: currentCard.translation, isReviewPhase: currentCard.isReviewPhase, levelNumber: currentCard.levelNumber, isCorrect: isCorrect!, isReviewed: true, userAnswer: reviewViewModel.userInput), phraseID: currentCard.id)
                            phraseStudyViewModel.updatePhraseCards(phraseID: currentCard.id, result: isCorrect! ? .correct : .incorrect)
                        }
                    }
                    .disabled(reviewViewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -50)
            .disabled(isCorrect != nil)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(reviewViewModel.selectedTopicToReview.name)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Group {
                if isCorrect == nil {
                    Button("Finish") {
                        reviewViewModel.currIndex = 0
                        router.navigateTo(.recapView)
                        resetUserInput()
                    }
                    .foregroundColor(Color.red)
                    .fontWeight(.bold)
                }
            })

            if isCorrect != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut, value: isCorrect)
            }

            VStack {
                Spacer()
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator() {
                            resetUserInput()
                            self.isCorrect = nil

                            if let nextIndex = findNextUnansweredCard() {
                                reviewViewModel.currIndex = nextIndex
                            } else {
                                reviewViewModel.currIndex = 0
                                router.navigateTo(.recapView)
                            }
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: reviewViewModel.currentCard?.vocabulary ?? "") {
                            resetUserInput()
                            self.isCorrect = nil

                            if let nextIndex = findNextUnansweredCard() {
                                reviewViewModel.currIndex = nextIndex
                            } else {
                                reviewViewModel.currIndex = 0
                                router.navigateTo(.recapView)
                            }
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    }
                }
            }
            .animation(.easeInOut, value: isCorrect)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            reviewViewModel.fetchPhrasesToReviewToday(topicID: reviewViewModel.selectedTopicToReview.id, selectedLevel: levelSelectionViewModel.selectedLevel)
        }
        .onChange(of: reviewViewModel.currIndex, {
            reviewViewModel.updateCurrentCard()
        })
    }

    private func findNextUnansweredCard() -> Int? {
        let unansweredCards = reviewViewModel.phrasesToReview.enumerated().filter { index, card in
            return !reviewViewModel.answeredCardIndices.contains(index)
        }
        return unansweredCards.first?.offset
    }

    private func resetUserInput() {
        reviewViewModel.userInput = ""
        reviewViewModel.isRevealed = false
    }
}
