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
    
    @State private var shuffledLetters: [(letter: String, index: Int)] = []
    @State private var usedIndices: Set<Int> = []
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ForEach(shuffledLetters, id: \.index) { letterInfo in
                    Button(action: {
                        if usedIndices.contains(letterInfo.index) {
                            if let lastIndex = reviewViewModel.userInput.lastIndex(of: letterInfo.letter.first!) {
                                reviewViewModel.userInput.remove(at: lastIndex)
                                usedIndices.remove(letterInfo.index)
                            }
                        } else {
                            reviewViewModel.userInput.append(letterInfo.letter.first!)
                            usedIndices.insert(letterInfo.index)
                        }
                    }) {
                        Text(letterInfo.letter)
                            .font(.system(size: 24))
                            .padding(8)
                            .background(usedIndices.contains(letterInfo.index) ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                    .disabled(usedIndices.contains(letterInfo.index) && !reviewViewModel.userInput.contains(letterInfo.letter.first!))
                }
            }
            .padding()
            
//            HStack {
//                Button("Clear Last Letter") {
//                    if !reviewViewModel.userInput.isEmpty {
//                        // Remove the last letter from userInput
//                        let lastLetter = reviewViewModel.userInput.removeLast()
//                        
//                        // Find and remove the index in usedIndices for the last letter added
//                        if let lastUsedIndex = shuffledLetters.first(where: { $0.letter.first == lastLetter && usedIndices.contains($0.index) })?.index {
//                            usedIndices.remove(lastUsedIndex)
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(4)
//            }
        }
        .onAppear {
            if let card = currentCard {
                initializeShuffledLetters(for: card)
            }
        }
        .onChange(of: currentCard) { newCard in
            if let card = newCard {
                reviewViewModel.userInput = ""
                usedIndices = []
                initializeShuffledLetters(for: card)
            }
        }
    }
    
    private func initializeShuffledLetters(for card: PhraseCardModel) {
        let letters = card.vocabulary.map { String($0) }
        shuffledLetters = letters.enumerated().map { (index, letter) in
            (letter: letter, index: index)
        }.shuffled()
    }
}
