//
//  FlashcardLibrary.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 09/10/24.
//

import SwiftUI

struct Constants {
    static let GraysBlack = Color.black // Define your color constant here
}

struct FlashcardLibrary: View { // Flashcard view for displaying each card
    var englishText: String
    var indonesianText: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.gray) // Fill color for the card
                .overlay(
                    RoundedRectangle(cornerRadius: 25) // Border overlay
                        .stroke(Constants.GraysBlack, lineWidth: 1) // Add border stroke
                )
                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2) // Add shadow effect

            VStack(spacing: 40) {
                Text(englishText) // English sentence
                    .font(.headline)
                Divider()
                    .frame(maxWidth: 178)
                Text(indonesianText) // Indonesian translation
                    .font(.subheadline)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
    }
}

struct SwipeableFlashcardsView: View {
    @State private var cardOffset: CGSize = .zero
    @State private var currIndex: Int = 0

    private let flashcards = [
        ("I don't have that pain anymore", "Saya sudah tidak merasakan sakit itu lagi"),
        ("I am feeling better now", "Saya merasa lebih baik sekarang"),
        ("Where are you going?", "Kamu mau ke mana?"),
        ("What's the matter?", "Ada masalah apa?"),
        ("Please wait for a moment", "Tolong tunggu sebentar"),
        ("Can I have a glass of water?", "Bolehkah saya minta segelas air?")
    ]
    
    var body: some View {
        VStack {
            ZStack {
                // Show up to 5 cards in the stack
                ForEach(currIndex..<min(currIndex + 5, flashcards.count), id: \.self) { index in
                    let yOffset: CGFloat = index == currIndex ? 0 : CGFloat((index - currIndex) * 10) // Adjust the y position for cards behind the top card

                    FlashcardLibrary(englishText: flashcards[index].0, indonesianText: flashcards[index].1)
                        .offset(x: index == currIndex ? cardOffset.width : 0, y: yOffset) // Use yOffset for behind cards
                        .rotationEffect(index == currIndex ? .degrees(Double(cardOffset.width / 15)) : .degrees(0)) // Rotate only the top card
                        .scaleEffect(index == currIndex ? 1.0 : 1.0) // Scale down other cards
                        .animation(.easeIn(duration: 0.3), value: cardOffset) // Smooth animation duration
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    cardOffset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.width > 100 {
                                        // Swipe right for "Okay"
                                        swipeRight()
                                    } else if value.translation.width < -100 {
                                        // Swipe left for "Skip"
                                        swipeLeft()
                                    } else {
                                        // Reset if insufficient swipe
                                        cardOffset = .zero
                                    }
                                }
                        )
                        .zIndex(Double(flashcards.count - index)) // Stack cards
                }
            }
            .frame(width: 265, height: 368)
        }
    }

    private func swipeRight() {
        withAnimation {
            cardOffset = CGSize(width: 500, height: 0) // Move card to the right
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Okay: \(flashcards[currIndex].0)")
            moveToNextCard()
        }
    }

    private func swipeLeft() {
        withAnimation {
            cardOffset = CGSize(width: -500, height: 0) // Move card to the left
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Skip: \(flashcards[currIndex].0)")
            moveToNextCard()
        }
    }

    private func moveToNextCard() {
        cardOffset = .zero // Reset the card position
        currIndex = (currIndex + 1) % flashcards.count // Loop to the next card
    }
}

#Preview {
    SwipeableFlashcardsView()
}

