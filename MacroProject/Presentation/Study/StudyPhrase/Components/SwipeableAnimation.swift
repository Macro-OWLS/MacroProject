import Foundation
import SwiftUI

struct StudyCarouselAnimation: View {
    @EnvironmentObject var viewModel: StudyPhraseCardViewModel
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(viewModel.phraseCards.enumerated()), id: \.element.id) { index, phrase in
                    if viewModel.currIndex == index {
                        FlashcardStudy(englishText: phrase.phrase, indonesianText: phrase.translation)
                            .opacity(viewModel.currIndex == index ? 1.0 : 0.5)
                            .scaleEffect(viewModel.currIndex == index ? 1.0 : 0.9)
                            .offset(x: viewModel.getOffset(for: index), y: 0)
                            .zIndex(viewModel.currIndex == index ? 1 : 0)
                    }
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

 
