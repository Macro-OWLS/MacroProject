//
//  RecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 10/10/24.
//

import SwiftUI

struct RecapView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 54) {
                
                // Header section with ZStack for title text
                VStack(alignment: .center, spacing: 32) {
                    Text("Well Done!")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 102, height: 30)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.36, green: 0.36, blue: 0.36))
                        .cornerRadius(10)
                    
                    // Correct and Incorrect answers section
                    VStack(alignment: .leading, spacing: 40) {
                        answerRow(answerNumber: "2", title: "Correct answers", subtitle: "Move to Level 3")
                        answerRow(answerNumber: "0", title: "Incorrect answers", subtitle: "Return to Level 1")
                    }
                }
                
                // Cards remaining section
                VStack(alignment: .center, spacing: 8) {
                    Text("Cards remaining to review:")
                        .font(Font.custom("HelveticaNeue-Light", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("0 Cards")
                        .font(Font.custom("HelveticaNeue-Bold", size: 22).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                
                // Buttons section
                HStack(alignment: .center, spacing: 8) {
                    // Add NavigationLink to navigate to ReviewRecapView
                    NavigationLink(destination: ReviewRecapView()) {
                        CustomButton(title: "Review Recap", backgroundColor: .clear, foregroundColor: Constants.GraysBlack, strokeColor: Constants.GraysBlack)
                    }
                    
                    CustomButton(title: "Back to Study", backgroundColor: Color(red: 0, green: 0.48, blue: 1), foregroundColor: .white)
                }
            }
            .frame(width: 291, alignment: .top)
            .padding(0)
        }
    }
    
    // Helper function for answer rows
    @ViewBuilder
    private func answerRow(answerNumber: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(answerNumber)
                .font(.system(size: 64))
                .bold()
                .foregroundColor(.black)
                .offset(y: -10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28))
                    .bold()
                    .kerning(0.38)
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
            }
        }
        .frame(width: 291, alignment: .leading)
    }
    
    // Custom button view for reusable button layout
    @ViewBuilder
    private func CustomButton(title: String, backgroundColor: Color, foregroundColor: Color, strokeColor: Color = .clear) -> some View {
        Text(title)
            .font(Font.custom("HelveticaNeue-Light", size: 17))
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(width: 148, alignment: .center)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
}

#Preview {
    RecapView()
}
