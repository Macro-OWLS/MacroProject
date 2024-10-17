//
//  FlashcardStudyView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct FlashcardStudyView: View {
    @StateObject private var viewModel: CarouselAnimationViewModel = CarouselAnimationViewModel()
    @ObservedObject var levelViewModel: LevelViewModel

    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false

    private var currentCard: PhraseCardModel {
        levelViewModel.selectedPhraseCardsToReviewByTopic[viewModel.currIndex]
    }

    var body: some View {
        ZStack {
            // Main flashcard content
            VStack(spacing: 24) {
                // Display current card number and total cards
                Text("\(viewModel.currIndex + 1)/\(levelViewModel.selectedPhraseCardsToReviewByTopic.count) Card Studied")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                // Use the CarouselAnimation view and pass the view model
                CarouselAnimation(viewModel: viewModel, levelViewModel: levelViewModel)

                VStack(spacing: 16) {
                    TextField("Input your answer", text: $viewModel.userInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 300)
                        .padding(.horizontal, 20)

                    // Button for checking answer
                    ZStack {
                        Rectangle()
                            .fill(viewModel.userInput.isEmpty ? Color.gray : Color.blue)
                            .frame(width: 125, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Constants.GraysBlack, lineWidth: 1))

                        Text("Check")
                            .font(.helveticaBody1)
                            .foregroundColor(Color.white)
                            .opacity(viewModel.userInput.isEmpty ? 0.5 : 1)
                    }
                    .onTapGesture {
                        if !viewModel.userInput.isEmpty {
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: viewModel.userInput, correctAnswer: currentCard.vocabulary)
                            viewModel.isRevealed = true
                            viewModel.addUserAnswer(userAnswer: UserAnswerDTO(id: String(viewModel.currIndex), topicID: currentCard.topicID, vocabulary: currentCard.vocabulary, phrase: currentCard.phrase, translation: currentCard.translation, isReviewPhase: currentCard.isReviewPhase, levelNumber: currentCard.levelNumber, isCorrect: isCorrect!, isReviewed: true, userAnswer: viewModel.userInput))
                        }
                    }
                    .disabled(viewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -125)
            .disabled(isCorrect != nil)  // Disable interaction with flashcards when the answer indicator is showing
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(levelViewModel.selectedTopicToReview.name)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Group {
                // Conditionally render the Finish button
                if isCorrect == nil {
                    Button("Finish") {
                        navigateToRecap = true
                    }
                    .disabled(viewModel.userInput.isEmpty)
                }
            })
            .navigationDestination(isPresented: $navigateToRecap) {
                RecapView(levelViewModel: levelViewModel, carouselAnimationViewModel: viewModel)
            }

            // Semi-transparent background layer when answer indicator is visible
            if isCorrect != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut, value: isCorrect)
            }

            VStack {
                Spacer()
                // Display the correct/incorrect answer indicator based on the user's answer
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator(viewModel: viewModel, levelViewModel: levelViewModel) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic) // Move to the next card
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: currentCard.vocabulary) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic) // Move to the next card
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


    // Function to reset the user input
    private func resetUserInput() {
        viewModel.userInput = ""
        viewModel.isRevealed = false
    }

// Preview
struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView(levelViewModel: LevelViewModel())
    }
}

//// Preview
//struct FlashcardStudyView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashcardStudyView(levelViewModel: LevelViewModel())
//    }
//}
