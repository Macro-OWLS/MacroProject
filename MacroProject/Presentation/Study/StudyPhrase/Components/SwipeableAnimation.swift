import Foundation
import SwiftUI

struct SwipeableFlashcardsView: View {
    @EnvironmentObject var phraseViewModel: StudyPhraseCardViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(phraseViewModel.currIndex..<min(phraseViewModel.currIndex + 5, phraseViewModel.phraseCards.count), id: \.self) { index in
                    SwipeableAnimation(index: index)
                }
            }
            .frame(width: 265, height: 368)
        }
    }
}

struct SwipeableAnimation: View {
    @EnvironmentObject var phraseViewModel: StudyPhraseCardViewModel
    private let phraseHelper: PhraseHelper
    private var index: Int
    
    init(index: Int) {
        self.phraseHelper = PhraseHelper()
        self.index = index
    }
    
    var body: some View {
        let yOffset: CGFloat = index == phraseViewModel.currIndex ? 0 : CGFloat((index - phraseViewModel.currIndex) * 10)
        let phrase = phraseViewModel.phraseCards[index]
        
        if !phrase.isReviewPhase {
            FlashcardStudy(
                englishText: phraseHelper.vocabSearch(
                    phrase: phrase.phrase,
                    vocab: phrase.vocabulary,
                    vocabEdit: .bold, userInput: "", isRevealed: false
                ),
                indonesianText: phrase.translation
            )
            .offset(x: index == phraseViewModel.currIndex ? phraseViewModel.cardOffset.width : 0, y: yOffset)
            .rotationEffect(index == phraseViewModel.currIndex ? .degrees(Double(phraseViewModel.cardOffset.width / 15)) : .degrees(0))
            .scaleEffect(index == phraseViewModel.currIndex ? 1.0 : 1.0)
            .animation(.easeIn(duration: 0.3), value: phraseViewModel.cardOffset)
            .gesture(flashcardGesture(index: index))
            .zIndex(Double(phraseViewModel.phraseCards.count - index))
        }
    }
    
    private func flashcardGesture(index: Int) -> some Gesture {
        DragGesture()
            .onChanged { value in
                phraseViewModel.cardOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > 100 {
                    phraseViewModel.updatePhraseCards(phraseID: phraseViewModel.phraseCards[index].id, result: .undefinedResult)
                    phraseViewModel.librarySwipeRight()
                    phraseViewModel.cardsAdded += 1
                } else if value.translation.width < -100 {
                    phraseViewModel.librarySwipeLeft()
                } else {
                    phraseViewModel.cardOffset = .zero
                }
            }
    }
}
