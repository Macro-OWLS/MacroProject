//
//  CarouselAnimationViewModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 14/10/24.
//

import SwiftUI

// View Model: Manages the carousel state and logic
class CarouselAnimationViewModel: ObservableObject {
    @Published var currIndex: Int // Keep current index variable
    @Published var isRevealed: Bool
    @Published var userInput: String
    @Published var recapAnsweredPhraseCards: [UserAnswerDTO]

    // Updated initializer to include currIndex
    init(currIndex: Int = 0) {
        self.currIndex = currIndex // Set the initial current index
        self.isRevealed = false
        self.userInput = ""
        self.recapAnsweredPhraseCards = []
    }
    
    func addUserAnswer(userAnswer: UserAnswerDTO) {
        recapAnsweredPhraseCards.append(userAnswer)
    }
    
    func moveToNextCard(phraseCards: [PhraseCardModel]) {
        if currIndex < phraseCards.count - 1 {
            currIndex += 1 // Increment index if not at the last card
        }
    }
    
    func moveToPreviousCard() {
        if currIndex > 0 { currIndex -= 1 }
    }

    func getOffset(for index: Int) -> CGFloat {
        switch index {
        case currIndex: return 0
        case let x where x < currIndex: return -50
        case let x where x > currIndex: return 50
        default: return 0
        }
    }
}
