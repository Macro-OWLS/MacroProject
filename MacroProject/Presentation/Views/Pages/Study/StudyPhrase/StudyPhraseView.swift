import SwiftUI


struct StudyPhraseView: View {
    @EnvironmentObject var phraseLibraryViewModel: PhraseCardViewModel
    @EnvironmentObject var studyViewModel: StudyPhraseViewModel
    @EnvironmentObject var router: Router
    
    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false
    
    private var currentCard: PhraseCardModel {
        studyViewModel.phrasesToStudy[studyViewModel.currIndex]
    }

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\(studyViewModel.unansweredPhrasesCount) Card(s) left")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                CarouselAnimation()

                VStack(spacing: 16) {
                    TextField("Input your answer", text: $studyViewModel.userInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 300)
                        .padding(.horizontal, 20)

                    ZStack {
                        Rectangle()
                            .fill(studyViewModel.userInput.isEmpty ? Color.gray : Color.blue)
                            .frame(width: 125, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.black, lineWidth: 1))

                        Text("Check")
                            .font(.helveticaBody1)
                            .foregroundColor(Color.white)
                            .opacity(studyViewModel.userInput.isEmpty ? 0.5 : 1)
                    }
                    .onTapGesture {
                        if !studyViewModel.userInput.isEmpty {
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: studyViewModel.userInput, correctAnswer: currentCard.vocabulary)
                            studyViewModel.isRevealed = true
                            studyViewModel.addUserAnswer(userAnswer: UserAnswerDTO(id: String(studyViewModel.currIndex), topicID: currentCard.topicID, vocabulary: currentCard.vocabulary, phrase: currentCard.phrase, translation: currentCard.translation, isReviewPhase: currentCard.isReviewPhase, levelNumber: currentCard.levelNumber, isCorrect: isCorrect!, isReviewed: true, userAnswer: studyViewModel.userInput), phraseID: currentCard.id)
                            phraseLibraryViewModel.updatePhraseCards(phraseID: currentCard.id, result: isCorrect! ? .correct : .incorrect)
                            
                        }
                    }
                    .disabled(studyViewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -125)
            .disabled(isCorrect != nil)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(studyViewModel.selectedTopicToReview.name)
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
                RecapView(selectedView: .constant(.study))
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
                                studyViewModel.currIndex = nextIndex
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
                                studyViewModel.currIndex = nextIndex
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
        let unansweredCards = studyViewModel.phrasesToStudy.enumerated().filter { index, card in
            return !studyViewModel.answeredCardIndices.contains(index)
        }
        return unansweredCards.first?.offset
    }

    private func resetUserInput() {
        studyViewModel.userInput = ""
        studyViewModel.isRevealed = false
    }
}
