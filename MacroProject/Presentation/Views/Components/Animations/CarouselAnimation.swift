//
//  CarouselAnimation.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//
import Foundation
import SwiftUI

// View: Displays the carousel of flashcards
struct CarouselAnimation: View {
    @ObservedObject var viewModel: CarouselAnimationViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<viewModel.flashcards.count, id: \.self) { index in
                    if abs(viewModel.currIndex - index) <= 1 {
                        Flashcard() // Your flashcard view
                            .opacity(viewModel.currIndex == index ? 1.0 : 0.5)
                            .scaleEffect(viewModel.currIndex == index ? 1.0 : 0.9)
                            .offset(x: viewModel.getOffset(for: index), y: 0)
                            .zIndex(viewModel.currIndex == index ? 1 : 0)
                    }
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
                                viewModel.moveToNextCard()
                            }
                        }
                    }
            )
        }
    }
}


