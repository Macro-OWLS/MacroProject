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
    let totalCards: Int

    // Updated initializer to include currIndex
    init(currIndex: Int = 0) {
        self.currIndex = currIndex // Set the initial current index
        self.totalCards = phraseCards.count // Set totalCards based on the number of phraseCards
        self.isRevealed = false
        self.userInput = ""
        self.recapAnsweredPhraseCards = []
    }
    
    var phraseCards: [PhraseCardModel] = [
        .init(id: "1", topicID: "topic1", vocabulary: "apple", phrase: "apple hijau", translation: "apel", isReviewPhase: false, levelNumber: "1"),
        .init(id: "2", topicID: "topic1", vocabulary: "orange", phrase: "jeruk kuning", translation: "jeruk", isReviewPhase: false, levelNumber: "1"),
    ]
    
    func moveToNextCard() {
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
