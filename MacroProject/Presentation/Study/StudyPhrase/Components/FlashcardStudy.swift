//
//  FlashcardStudy.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 09/10/24.
//

import SwiftUI

struct FlashcardStudy: View {
    var englishText: String
    var indonesianText: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.darkcream)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 1)
                )

            VStack(spacing: 40) {
                Text(.init(englishText))
                    .font(.helveticaHeader3)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Divider()
                    .frame(maxWidth: 178)
                Text(.init(indonesianText))
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

