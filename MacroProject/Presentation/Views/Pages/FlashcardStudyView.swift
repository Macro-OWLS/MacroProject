//
//  FlashcardStudyView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI
import Routing

struct FlashcardStudyView: View {
    @StateObject private var viewModel: CarouselAnimationViewModel = CarouselAnimationViewModel()
    @ObservedObject var levelViewModel: LevelViewModel
    @ObservedObject var phraseViewModel: PhraseCardViewModel
    
    @State private var isCorrect: Bool? = nil
    @State private var navigateToRecap: Bool = false
    
    @StateObject var router: Router<NavigationRoute>
    
    init(levelViewModel: LevelViewModel, phraseViewModel: PhraseCardViewModel, router: Router<NavigationRoute>) {
        self.levelViewModel = levelViewModel
        self.phraseViewModel = phraseViewModel
        _router = StateObject(wrappedValue: router)
    }
    
    private var curretCard: PhraseCardModel {
        levelViewModel.selectedPhraseCardsToReviewByTopic[viewModel.currIndex]
    }
    
    var body: some View {
        ZStack {
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
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: viewModel.userInput, correctAnswer: curretCard.vocabulary)
                            viewModel.isRevealed = true
                            viewModel.addUserAnswer(userAnswer: UserAnswerDTO(id: String(viewModel.currIndex), vocabulary: curretCard.vocabulary, phrase: curretCard.phrase, translation: curretCard.translation, isReviewPhase: curretCard.isReviewPhase, levelNumber: curretCard.levelNumber, isCorrect: isCorrect!, isReviewed: true))
                        }
                    }
                    .disabled(viewModel.userInput.isEmpty)
                }
            }
            .padding(.top, -90)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(levelViewModel.selectedTopicToReview.name)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button("Finish") {
                navigateToRecap = true
            })
            .navigationDestination(isPresented: $navigateToRecap) {
                RecapView(router: router, carouselAnimationViewModel: viewModel ,levelViewModel: levelViewModel, selectedView: .constant(.study))
            }
            
            VStack {
                Spacer()
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator(viewModel: viewModel, levelViewModel: levelViewModel) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic) // Move to the next card
                            phraseViewModel.updatePhraseCards(phraseID: curretCard.id, result: .correct)
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: curretCard.vocabulary) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic) // Move to the next card
                            phraseViewModel.updatePhraseCards(phraseID: curretCard.id, result: .incorrect)
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
}

//// Preview
//struct FlashcardStudyView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashcardStudyView(levelViewModel: LevelViewModel())
//    }
//}
