//
//  Sw.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//
import Foundation
import SwiftUI

struct SwipeableFlashcardsView: View {
    @ObservedObject var viewModel: PhraseCardViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(viewModel.currIndex..<min(viewModel.currIndex + 5, viewModel.phraseCards.count), id: \.self) { index in
                    SwipeableAnimation(viewModel: viewModel, phraseHelper: PhraseHelper(), index: index)
                }
            }
            .frame(width: 265, height: 368)
        }
    }
}

struct SwipeableAnimation: View {
    @ObservedObject var viewModel: PhraseCardViewModel
    private let phraseHelper: PhraseHelper
    private var index: Int
    
    init(viewModel: PhraseCardViewModel, phraseHelper: PhraseHelper, index: Int) {
        self.viewModel = viewModel
        self.phraseHelper = phraseHelper
        self.index = index
    }
    
    var body: some View {
        let yOffset: CGFloat = index == viewModel.currIndex ? 0 : CGFloat((index - viewModel.currIndex) * 10)
        let phrase = viewModel.phraseCards[index]
        if !phrase.isReviewPhase {
            FlashcardLibrary(
                englishText: phraseHelper.vocabSearch(
                    phrase: phrase.phrase,
                    vocab: phrase.vocabulary,
                    vocabEdit: .bold
                ),
                indonesianText: phrase.translation
            )
            .offset(x: index == viewModel.currIndex ? viewModel.cardOffset.width : 0, y: yOffset)
            .rotationEffect(index == viewModel.currIndex ? .degrees(Double(viewModel.cardOffset.width / 15)) : .degrees(0))
            .scaleEffect(index == viewModel.currIndex ? 1.0 : 1.0)
            .animation(.easeIn(duration: 0.3), value: viewModel.cardOffset)
            .gesture(flashcardGesture(index: index))
            .zIndex(Double(viewModel.phraseCards.count - index))
        }
    }
    
    private func flashcardGesture(index: Int) -> some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.cardOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > 100 {
                    viewModel.updatePhraseCards(phraseID: viewModel.phraseCards[index].id, result: .undefinedResult)
                    viewModel.librarySwipeRight()
                    viewModel.cardsAdded += 1
                } else if value.translation.width < -100 {
                    viewModel.librarySwipeLeft()
                } else {
                    viewModel.cardOffset = .zero
                }
            }
    }
}
