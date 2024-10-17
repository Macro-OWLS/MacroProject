//
//  CarouselAnimationViewModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 14/10/24.
//

import SwiftUI

class CarouselAnimationViewModel: ObservableObject {
    @Published var currIndex: Int
    @Published var isRevealed: Bool
    @Published var userInput: String
    @Published var recapAnsweredPhraseCards: [UserAnswerDTO]
    @Published var answeredCardIndices: Set<Int> = []

    // New property to control visibility of the answered card
    @Published var isAnswerIndicatorVisible: Bool = false

    init(currIndex: Int = 0) {
        self.currIndex = currIndex
        self.isRevealed = false
        self.userInput = ""
        self.recapAnsweredPhraseCards = []
    }

    func addUserAnswer(userAnswer: UserAnswerDTO) {
        recapAnsweredPhraseCards.append(userAnswer)
        answeredCardIndices.insert(currIndex) // Mark current index as answered
        isAnswerIndicatorVisible = true // Show the answer indicator
    }

    func moveToNextCard(phraseCards: [PhraseCardModel]) {
        // Reset visibility and update index
        isAnswerIndicatorVisible = false

        // Move to next card logic (skipping answered cards)
        var newIndex = currIndex + 1
        while newIndex < phraseCards.count && answeredCardIndices.contains(newIndex) {
            newIndex += 1
        }
        if newIndex < phraseCards.count {
            currIndex = newIndex
        }
    }

    func moveToPreviousCard() {
        // Move backward skipping answered cards
        var newIndex = currIndex - 1
        while newIndex >= 0 && answeredCardIndices.contains(newIndex) {
            newIndex -= 1
        }
        if newIndex >= 0 {
            currIndex = newIndex
        }
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
