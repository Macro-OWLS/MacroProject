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
    @ObservedObject var phraseCardViewModel: PhraseCardViewModel

    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false

    private var currentCard: PhraseCardModel {
        levelViewModel.selectedPhraseCardsToReviewByTopic[viewModel.currIndex]
    }

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\(viewModel.currIndex + 1)/\(levelViewModel.selectedPhraseCardsToReviewByTopic.count) Card Studied")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text("Last review date \(currentCard.lastReviewedDate)")
                Text("Next review date \(currentCard.nextReviewDate)")

                CarouselAnimation(viewModel: viewModel, levelViewModel: levelViewModel)

                VStack(spacing: 16) {
                    TextField("Input your answer", text: $viewModel.userInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 300)
                        .padding(.horizontal, 20)

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
                            phraseCardViewModel.updatePhraseCards(phraseID: currentCard.id, result: isCorrect! ? .correct : .incorrect)
                        }
                    }
                    .disabled(viewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -125)
            .disabled(isCorrect != nil)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(levelViewModel.selectedTopicToReview.name)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Group {
                if isCorrect == nil {
                    Button("Finish") {
                        navigateToRecap = true
                    }
                    .foregroundColor(Color.blue) // Change the button color to blue here
                }
            })
            .navigationDestination(isPresented: $navigateToRecap) {
                RecapView(levelViewModel: levelViewModel, carouselAnimationViewModel: viewModel)
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
                        CorrectAnswerIndicator(viewModel: viewModel, levelViewModel: levelViewModel) {
                            resetUserInput()
                            self.isCorrect = nil

                            if let nextIndex = findNextUnansweredCard() {
                                viewModel.currIndex = nextIndex
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
                                viewModel.currIndex = nextIndex
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
        let unansweredCards = levelViewModel.selectedPhraseCardsToReviewByTopic.enumerated().filter { index, card in
            return !viewModel.answeredCardIndices.contains(index)
        }
        return unansweredCards.first?.offset
    }

    private func resetUserInput() {
        viewModel.userInput = ""
        viewModel.isRevealed = false
    }
}

struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView(levelViewModel: LevelViewModel())
            .background(Color.cream)
    }
}
