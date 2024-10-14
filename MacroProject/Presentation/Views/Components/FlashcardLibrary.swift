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
                Text(.init(englishText)) // English sentence
                    .font(.subheadline)
                Divider()
                    .frame(maxWidth: 178)
                Text(.init(indonesianText)) // Indonesian translation
                    .font(.subheadline)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
    }
}
