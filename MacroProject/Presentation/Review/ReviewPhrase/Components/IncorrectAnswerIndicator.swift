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
                .fill(Color(red: 229 / 255, green: 207 / 255, blue: 207 / 255))
                .frame(width: 403, height: 284, alignment: .leading)
                .cornerRadius(30)

            VStack(alignment: .center) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "xmark.square.fill")
                                .font(.poppinsH2)
                                .foregroundColor(Color(red: 0.49, green: 0, blue: 0))
                            Text("Incorrect!")
                                .font(.poppinsH2)
                                .kerning(0.38)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.black)
                                .fontWeight(.semibold)
                        })
                        .padding(.bottom, 20-4)
                        
                        Text("Correct Answer:")
                            .font(.poppinsB1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                        
                        Text(correctAnswer.capitalized)
                            .font(.poppinsHd)
                            .underline()
                            .foregroundColor(Color.black)
                    }
                    .padding(.leading, 22)
                    
                    Spacer()
                    Image("SadCapybara")
                        .offset(y: -7)
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 201, height: 50, alignment: .leading)
                        .cornerRadius(12)
                    Text("Next")
                        .font(.poppinsB1)
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)
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

