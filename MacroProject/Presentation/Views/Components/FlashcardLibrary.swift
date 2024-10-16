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
                .fill(Color.cream) // Fill color for the card
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Constants.GraysBlack, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)

            VStack(spacing: 40) {
                Text(.init(englishText)) // English sentence
                    .font(.helveticaBody1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Divider()
                    .frame(maxWidth: 178)
                Text(.init(indonesianText)) // Indonesian translation
                    .font(.helveticaBody1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .allowsTightening(false)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
    }
}

