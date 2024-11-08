import SwiftUI


struct ReviewPhraseView: View {
    @EnvironmentObject var phraseStudyViewModel: StudyPhraseCardViewModel
    @EnvironmentObject var reviewViewModel: ReviewPhraseViewModel
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
    @EnvironmentObject var router: Router
    
    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\(reviewViewModel.unansweredPhrasesCount) Card(s) left")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                CarouselAnimation()

                VStack(spacing: 16) {
                    TextField("Input your answer", text: $reviewViewModel.userInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 300)
                        .padding(.horizontal, 20)
                    
                    ScrabbleComponent(currentCard: reviewViewModel.currentCard)

                    ZStack {
                        Rectangle()
                            .fill(reviewViewModel.userInput.isEmpty ? Color.gray : Color.blue)
                            .frame(width: 125, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.black, lineWidth: 1))

                        Text("Check")
                            .font(.helveticaBody1)
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
                        navigateToRecap = true
                        resetUserInput()
                    }
                    .foregroundColor(Color.blue)
                }
            })
            .navigationDestination(isPresented: $navigateToRecap) {
                RecapView()
            }

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
                                navigateToRecap = true
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
                                navigateToRecap = true
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
