import Foundation
import SwiftUI

struct StudyCarouselAnimation: View {
    @EnvironmentObject var viewModel: StudyPhraseCardViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(viewModel.phraseCards.enumerated()), id: \.element.id) { index, phrase in
                    FlashcardStudy(
                        englishText: PhraseHelper().vocabSearch(
                            phrase: phrase.phrase,
                            vocab: phrase.vocabulary,
                            vocabEdit: .bold,
                            userInput: "",
                            isRevealed: false
                        ),
                        indonesianText: PhraseHelper().vocabSearch(
                            phrase: phrase.translation,
                            vocab: phrase.vocabularyTranslation ?? "",
                            vocabEdit: .bold,
                            userInput: "",
                            isRevealed: false
                        )
                    )
                    .opacity(viewModel.opacity(for: index))
                    .scaleEffect(viewModel.scale(for: index))
                    .offset(x: viewModel.getOffset(for: index), y: 0)
                    .zIndex(viewModel.currIndex == index ? 1 : 0)
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    viewModel.moveToPreviousCard()
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    viewModel.moveToNextCard(phraseCards: viewModel.phraseCards)
                                }
                            }
                        }
                )
            }
        }
    }
}

