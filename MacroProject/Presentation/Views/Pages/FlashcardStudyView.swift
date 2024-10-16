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
    @State private var isCorrect: Bool? = nil
    private let answerDetectionHelper = AnswerDetectionHelper()
    private let phraseHelper = PhraseHelper()

    private var correctAnswer: String {
        viewModel.phraseCards[viewModel.currIndex].vocabulary
    }

    init() {
        // Create an array of PhraseCardModel
        let phraseCards = [
            PhraseCardModel(id: "1", topicID: "topic1", vocabulary: "apple", phrase: "apple hijau", translation: "apel", isReviewPhase: false, levelNumber: "1"),
            PhraseCardModel(id: "2", topicID: "topic1", vocabulary: "orange", phrase: "jeruk kuning", translation: "jeruk", isReviewPhase: false, levelNumber: "1"),
            // Add more PhraseCardModel instances as needed
        ]
        // Initialize the view model with the array
        self.viewModel = CarouselAnimationViewModel(phraseCards: phraseCards)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 24) {
                    // Display current card number and total cards
                    Text("\(viewModel.currIndex + 1)/\(viewModel.totalCards) Card Studied")
                        .font(.helveticaHeader3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    // Use the CarouselAnimation view and pass the view model
                    CarouselAnimation(viewModel: viewModel, phraseCards: viewModel.phraseCards, phraseHelper: phraseHelper)
                    
                    VStack(spacing: 16) {
                        TextField("Input your answer", text: $userInput)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 300)
                            .padding(.horizontal, 20)
                        
                        // Button for checking answer
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
            
            // Overlay for the answer indicators at the bottom
            VStack {
                Spacer()
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator() // Show correct indicator
                            .frame(height: 222)
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: correctAnswer)
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
}

// Preview
struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView()
    }
}
