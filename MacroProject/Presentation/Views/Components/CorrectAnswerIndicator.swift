//
//  CorrectAnswerIndicator.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 15/10/24.
//

import SwiftUI

struct CorrectAnswerIndicator: View {
    @ObservedObject var viewModel: CarouselAnimationViewModel
    var onNext: () -> Void
    var resetUserInput: (() -> Void)? // Closure for additional action

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 403, height: 222, alignment: .leading)
                .cornerRadius(30)
                .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 91) {
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "checkmark.square.fill")
                        .font(.helveticaHeader2)
                        .foregroundColor(Color(red: 0, green: 0.49, blue: 0.08))
                    
                    Text("Correct!")
                        .font(.helveticaHeader2)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                }
                .padding(.top, 24)
                
                Button(action: {
//                    viewModel.moveToNextCard()
                    onNext()
                    resetUserInput?() // Call the additional action to reset the text field
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.cream)
                            .frame(width: 345, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Constants.GraysBlack, lineWidth: 1)
                            )
                        
                        Text("Next")
                            .font(.helveticaBody1)
                            .foregroundColor(Color.black)
                    }
                    .padding(.bottom, 28)
            
                }
            }
        }
    }
}


