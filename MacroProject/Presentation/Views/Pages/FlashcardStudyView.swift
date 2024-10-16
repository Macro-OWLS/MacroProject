//
//  FlashcardStudyView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct FlashcardStudyView: View {
    @State private var userInput: String = ""
    @ObservedObject private var viewModel = CarouselAnimationViewModel(totalCards: 6)
    @State private var isCorrect: Bool? = nil
    let correctAnswer = "apel"
    private let answerDetectionModel = AnswerDetectionModel()
    
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
                    CarouselAnimation(viewModel: viewModel)
                    
                    VStack(spacing: 16) {
                        TextField("Input your answer", text: $userInput)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 300) // Adjust the width
                            .padding(.horizontal, 20)
                        
                        // Button for checking answer
                        ZStack {
                            Rectangle()
                                .fill(userInput.isEmpty ? Color.gray : Color.blue) // Change color based on user input
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
                                .opacity(userInput.isEmpty ? 0.5 : 1) // Make text less visible if the button is disabled
                        }
                        .onTapGesture {
                            if !userInput.isEmpty { // Only check if input is not empty
                                isCorrect = answerDetectionModel.isAnswerCorrect(userInput: userInput, correctAnswer: correctAnswer)
                            }
                        }
                        .disabled(userInput.isEmpty) // Disable button when user input is empty
                    }
                }
                .padding(.top, -90) // Adjust this as needed for spacing from the top
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Flashcard Study")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing: Button("Finish") {
                    print("Finish button tapped")
                })
            }
            
            // Overlay for the answer indicators at the bottom
            VStack {
                Spacer() // Push the indicators to the bottom
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator() // Show correct indicator
                            .frame(height: 222)
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    } else {
                        IncorrectAnswerIndicator(correctAnswer: correctAnswer) // Pass the correct answer here
                            .frame(height: 222)
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    }
                }
            }
            .animation(.easeInOut, value: isCorrect) // Animate the appearance
        }
        .edgesIgnoringSafeArea(.bottom) // Ignore safe area at the bottom so it fully overlaps content
    }
}

// Preview
struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView()
    }
}
