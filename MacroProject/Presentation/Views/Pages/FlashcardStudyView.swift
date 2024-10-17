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
    
    private var correctAnswer: String {
        viewModel.phraseCards[viewModel.currIndex].vocabulary
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // Display current card number and total cards
                Text("\(viewModel.currIndex + 1)/\(viewModel.totalCards) Card Studied")
                    .font(.helveticaHeader3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                // Use the CarouselAnimation view and pass the view model
                CarouselAnimation(viewModel: viewModel)
                
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
                            isCorrect = AnswerDetectionHelper().isAnswerCorrect(userInput: viewModel.userInput, correctAnswer: correctAnswer)
                            viewModel.isRevealed = true
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
                print("Finish button tapped")
            })
            
            // Overlay for the answer indicators at the bottom
            VStack {
                Spacer()
                if let isCorrect = isCorrect {
                    if isCorrect {
                        CorrectAnswerIndicator(viewModel: viewModel)
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
        FlashcardStudyView(levelViewModel: LevelViewModel())
    }
}
