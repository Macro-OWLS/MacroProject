//
//  CarouselAnimationViewModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 14/10/24.
//

import SwiftUI

// View Model: Manages the carousel state and logic
class CarouselAnimationViewModel: ObservableObject {
    @Published var currIndex: Int = 0
    let totalCards: Int
    var flashcards: [String]

    init(totalCards: Int) {
        self.totalCards = totalCards
        // Dynamically create an array of flashcards based on totalCards
        self.flashcards = Array(repeating: "Flashcard", count: totalCards)
    }
    
    func moveToNextCard() {
        currIndex = min(flashcards.count - 1, currIndex + 1)
    }
    
    func moveToPreviousCard() {
        currIndex = max(0, currIndex - 1)
    }

    func getOffset(for index: Int) -> CGFloat {
        if index == currIndex {
            return 0 // Center card
        } else if index < currIndex {
            return -50 // Previous card
        } else {
            return 50 // Next card
        }
    }
}
