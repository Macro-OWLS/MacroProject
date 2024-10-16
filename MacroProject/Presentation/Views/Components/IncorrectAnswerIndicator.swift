//
//  IncorrectAnswerIndicator.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 15/10/24.
//

import SwiftUI

struct IncorrectAnswerIndicator: View {
    var correctAnswer: String // Property to hold the correct answer

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
                        .font(.helveticaHeader2)
                        .foregroundColor(Color(red: 0.49, green: 0, blue: 0))
                    
                    Text("Incorrect!")
                        .font(.helveticaHeader2)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                }
                .padding(.top, 24)
                
                // Adjusting the spacing to 13 between "Incorrect!" and "Correct Answer:"
                Spacer().frame(height: 13)
                
                Text("Correct Answer:")
                    .font(.helveticaBody1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.cream)
                
                // Adjusting the spacing to 5 between "Correct Answer:" and the correct answer text
                Spacer().frame(height: 5)
                
                Text(correctAnswer.capitalized) // Display the correct answer here
                    .font(.helveticaHeadline)
                    .underline()
                    .foregroundColor(Color.cream)
                
                // Adjusting the spacing to 23 between the correct answer and the "Next" button
                Spacer().frame(height: 23)

                ZStack {
                    Rectangle()
                        .fill(Color.cream)
                        .frame(width: 345, height: 50, alignment: .leading)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Constants.GraysBlack, lineWidth: 1))
                    
                    Text("Next")
                        .font(.helveticaBody1)
                        .foregroundColor(Color.black)
                }
                .padding(.bottom, 28)
            }
        }
    }
}

#Preview {
    IncorrectAnswerIndicator(correctAnswer: "Disorder") // Example usage with a correct answer
}
