//
//  ReviewBox.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 01/10/24.
//

import SwiftUI

struct ReviewBox: View {
    var level: Level
    var color: Color
    var strokeColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(level.title)
                    .font(.helveticaHeadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(level.description)
                    .font(.helveticaBody1)
                    .frame(maxWidth: 305, alignment: .leading)
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .font(.title2)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(color)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .inset(by: 0.5)
                .stroke(strokeColor, lineWidth: 1)
        )
    }
}
