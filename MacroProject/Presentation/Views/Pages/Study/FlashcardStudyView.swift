import SwiftUI
import Routing

struct FlashcardStudyView: View {
    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel
    @EnvironmentObject var phraseLibraryViewModel: PhraseCardViewModel
    @EnvironmentObject var topicStudyViewModel: TopicStudyViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
    
    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false
    
    @StateObject var router: Router<NavigationRoute>
    
    init(router: Router<NavigationRoute>) {
        _router = StateObject(wrappedValue: router)
    }
    
    private var currentCard: PhraseCardModel {
        phraseStudyViewModel.selectedPhraseCardsToReviewByTopic[phraseStudyViewModel.currIndex]
    }

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\(phraseStudyViewModel.currIndex + 1)/\(phraseStudyViewModel.selectedPhraseCardsToReviewByTopic.count) Card Studied")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                CarouselAnimation()

                VStack(spacing: 16) {
                    TextField("Input your answer", text: $phraseStudyViewModel.userInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 300)
                        .padding(.horizontal, 20)

                    ZStack {
                        Rectangle()
                            .fill(phraseStudyViewModel.userInput.isEmpty ? Color.gray : Color.blue)
                            .frame(width: 125, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Constants.GraysBlack, lineWidth: 1))

                        Text("Check")
                            .font(.helveticaBody1)
                            .foregroundColor(Color.white)
                            .opacity(phraseStudyViewModel.userInput.isEmpty ? 0.5 : 1)
                    }
                    .onTapGesture {
                        if !phraseStudyViewModel.userInput.isEmpty {
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: phraseStudyViewModel.userInput, correctAnswer: currentCard.vocabulary)
                            phraseStudyViewModel.isRevealed = true
                            phraseStudyViewModel.addUserAnswer(userAnswer: UserAnswerDTO(id: String(phraseStudyViewModel.currIndex), topicID: currentCard.topicID, vocabulary: currentCard.vocabulary, phrase: currentCard.phrase, translation: currentCard.translation, isReviewPhase: currentCard.isReviewPhase, levelNumber: currentCard.levelNumber, isCorrect: isCorrect!, isReviewed: true, userAnswer: phraseStudyViewModel.userInput))
                            phraseLibraryViewModel.updatePhraseCards(phraseID: currentCard.id, result: isCorrect! ? .correct : .incorrect)
                        }
                    }
                    .disabled(phraseStudyViewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -125)
            .disabled(isCorrect != nil)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(topicStudyViewModel.selectedTopicToReview.name)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Group {
                if isCorrect == nil {
                    Button("Finish") {
                        navigateToRecap = true
                    }
                    .foregroundColor(Color.blue)
                }
            })
            .navigationDestination(isPresented: $navigateToRecap) {
                RecapView(router: router, selectedView: .constant(.study))
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
                                phraseStudyViewModel.currIndex = nextIndex
                            } else {
                                navigateToRecap = true
                            }
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: currentCard.vocabulary) {
                            resetUserInput()
                            self.isCorrect = nil

                            if let nextIndex = findNextUnansweredCard() {
                                phraseStudyViewModel.currIndex = nextIndex
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
    }

    private func findNextUnansweredCard() -> Int? {
        let unansweredCards = phraseStudyViewModel.selectedPhraseCardsToReviewByTopic.enumerated().filter { index, card in
            return !phraseStudyViewModel.answeredCardIndices.contains(index)
        }
        return unansweredCards.first?.offset
    }

    private func resetUserInput() {
        phraseStudyViewModel.userInput = ""
        phraseStudyViewModel.isRevealed = false
    }
}
