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
    @Published var phraseCards: [PhraseCardModel] // Ensure the type is correct
    let totalCards: Int

    // Updated initializer to include currIndex
    init(currIndex: Int = 0, phraseCards: [PhraseCardModel]) {
        self.currIndex = currIndex // Set the initial current index
        self.phraseCards = phraseCards
        self.totalCards = phraseCards.count // Set totalCards based on the number of phraseCards
    }
    
    func moveToNextCard() {
        if currIndex < phraseCards.count - 1 {
            currIndex += 1 // Increment index if not at the last card
        }
    }
    
    func moveToPreviousCard() {
        if currIndex > 0 {
            currIndex -= 1 // Decrement index if not at the first card
        }
    }

    func getOffset(for index: Int) -> CGFloat {
        switch index {
        case currIndex:
            return 0 // Center card
        case let x where x < currIndex:
            return -50 // Previous card
        case let x where x > currIndex:
            return 50 // Next card
        default:
            return 0
        }
    }
}
