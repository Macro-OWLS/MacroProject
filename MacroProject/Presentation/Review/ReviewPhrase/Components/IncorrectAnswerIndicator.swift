//
//  IncorrectAnswerIndicator.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 15/10/24.
//

import SwiftUI

struct IncorrectAnswerIndicator: View {
    var correctAnswer: String
    var onNext: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 403, height: 222, alignment: .leading)
                .cornerRadius(30)
                .padding(.horizontal, 24)

            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "xmark.square.fill")
                        .font(.poppinsH2)
                        .foregroundColor(Color(red: 0.49, green: 0, blue: 0))

                    Text("Incorrect!")
                        .font(.poppinsH2)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                }
                .padding(.top, 24)

                Spacer().frame(height: 13)

                Text("Correct Answer:")
                    .font(.poppinsB1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.cream)

                Spacer().frame(height: 5)

                Text(correctAnswer.capitalized)
                    .font(.poppinsHd)
                    .underline()
                    .foregroundColor(Color.cream)

                Spacer().frame(height: 23)

                ZStack {
                    Rectangle()
                        .fill(Color.cream)
                        .frame(width: 345, height: 50, alignment: .leading)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Color.black, lineWidth: 1))

                    Text("Next")
                        .font(.poppinsB1)
                        .foregroundColor(Color.black)
                }
                .padding(.bottom, 28)
                .onTapGesture {
                    onNext()
                }
            }
        }
    }
}

#Preview {
    IncorrectAnswerIndicator(correctAnswer: "Disorder") {
        print("Next button tapped")
    }
}

