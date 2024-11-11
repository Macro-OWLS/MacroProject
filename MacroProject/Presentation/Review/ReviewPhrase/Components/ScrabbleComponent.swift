//
//  ScrabbleComponent.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct ScrabbleComponent: View {
    @EnvironmentObject var reviewViewModel: ReviewPhraseViewModel
    var currentCard: PhraseCardModel?
    
    var body: some View {
        VStack {
            let columns = Array(repeating: GridItem(.fixed(40), spacing: 8), count: 7)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(reviewViewModel.shuffledLetters, id: \.index) { letterInfo in
                    Button(action: {
                        if reviewViewModel.usedIndices.contains(letterInfo.index) {
                            if let lastIndex = reviewViewModel.userInput.lastIndex(of: letterInfo.letter.first!) {
                                reviewViewModel.userInput.remove(at: lastIndex)
                                reviewViewModel.usedIndices.remove(letterInfo.index)
                            }
                        } else {
                            reviewViewModel.userInput.append(letterInfo.letter.first!)
                            reviewViewModel.usedIndices.insert(letterInfo.index)
                        }
                    }) {
                        Text(letterInfo.letter)
                            .font(.poppinsB1)
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40, alignment: .center)
                            .background(reviewViewModel.usedIndices.contains(letterInfo.index) ? Color.darkGrey : Color.cream)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .disabled(reviewViewModel.usedIndices.contains(letterInfo.index) && !reviewViewModel.userInput.contains(letterInfo.letter.first!))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
        .frame(maxWidth: 352, maxHeight: 100, alignment: .center)
        .onAppear {
            if let card = currentCard {
                initializeShuffledLetters(for: card)
            }
        }
        .onChange(of: currentCard) { newCard in
            if let card = newCard {
                reviewViewModel.userInput = ""
                reviewViewModel.usedIndices = []
                initializeShuffledLetters(for: card)
            }
        }
    }
    
    private func initializeShuffledLetters(for card: PhraseCardModel) {
        let letters = card.vocabulary.map { String($0) }
        reviewViewModel.shuffledLetters = letters.enumerated().map { (index, letter) in
            (letter: letter, index: index)
        }.shuffled()
    }
}
