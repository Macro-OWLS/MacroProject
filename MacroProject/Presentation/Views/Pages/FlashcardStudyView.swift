//
//  FlashcardStudyView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct FlashcardStudyView: View {
    @State private var userInput: String = ""
    @ObservedObject private var viewModel: CarouselAnimationViewModel
    @State private var isCorrect: Bool? = nil // Keep this as an optional Bool
    private let answerDetectionHelper = AnswerDetectionHelper()
    private let phraseHelper = PhraseHelper()

    private var correctAnswer: String {
        viewModel.phraseCards[viewModel.currIndex].vocabulary
    }

    init() {
        let phraseCards = [
            PhraseCardModel(id: "1", topicID: "topic1", vocabulary: "apple", phrase: "green apple", translation: "apel hijau", isReviewPhase: false, levelNumber: "1"),
            PhraseCardModel(id: "2", topicID: "topic1", vocabulary: "orange", phrase: "sweet orange", translation: "jeruk", isReviewPhase: false, levelNumber: "1"),
            PhraseCardModel(id: "3", topicID: "topic1", vocabulary: "avocado", phrase: "big avocado", translation: "alpukat besar", isReviewPhase: false, levelNumber: "1"),
            PhraseCardModel(id: "4", topicID: "topic1", vocabulary: "banana", phrase: "yellow banana", translation: "pisang kuning", isReviewPhase: false, levelNumber: "1"),
            PhraseCardModel(id: "5", topicID: "topic1", vocabulary: "banana", phrase: "yellow banana", translation: "pisang kuning", isReviewPhase: false, levelNumber: "1"),
        ]
        self.viewModel = CarouselAnimationViewModel(phraseCards: phraseCards)
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 24) {
                    Text("\(viewModel.currIndex + 1)/\(viewModel.totalCards) Card Studied")
                        .font(.helveticaHeader3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    CarouselAnimation(viewModel: viewModel, phraseCards: viewModel.phraseCards, phraseHelper: phraseHelper)

                    VStack(spacing: 16) {
                        TextField("Input your answer", text: $userInput)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 300)
                            .padding(.horizontal, 20)

                        ZStack {
                            Rectangle()
                                .fill(userInput.isEmpty ? Color.gray : Color.blue)
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
                                .opacity(userInput.isEmpty ? 0.5 : 1)
                        }
                        .onTapGesture {
                            if !userInput.isEmpty {
                                isCorrect = answerDetectionHelper.isAnswerCorrect(userInput: userInput, correctAnswer: correctAnswer)
                            }
                        }
                        .disabled(userInput.isEmpty)
                    }
                }
                .padding(.top, -90)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Flashcard Study")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing: Button("Finish") {
                    print("Finish button tapped")
                })
            }
            
            VStack {
                Spacer()
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator(viewModel: viewModel) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard() // Move to the next card
                        }
                        .frame(height: 222)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: correctAnswer) {
                            resetUserInput() // Reset user input
                            self.isCorrect = nil  // Hide the indicator
                            viewModel.moveToNextCard() // Move to the next card
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
        userInput = ""
    }
}

// Preview
struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView()
    }
}
