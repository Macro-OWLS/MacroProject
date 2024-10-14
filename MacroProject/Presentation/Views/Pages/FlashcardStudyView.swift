//
//  FlashcardStudyView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct FlashcardStudyView: View {
    @State private var userInput: String = "" // State variable for TextField input
    @ObservedObject private var viewModel = CarouselAnimationViewModel(totalCards: 6) // Initialize view model with total cards

    var body: some View {
        NavigationView {
            VStack {
                // Display current card number and total cards
                Text("\(viewModel.currIndex + 1)/\(viewModel.totalCards) Card Studied")
                    .font(Font.custom("HelveticaNeue-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                // Use the CarouselAnimation view and pass the view model
                CarouselAnimation(viewModel: viewModel)
                
                // TextField for user input with adjustable width
                TextField("Input your answer", text: $userInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(width: 300) // Adjust the width
                    .padding(.horizontal, 20)
                
                // Button for checking answer
                Text("Check")
                    .font(Font.custom("SF Pro", size: 17))
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.12))
                    .cornerRadius(12)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Flashcard Study")
            .navigationBarBackButtonHidden(true) // Hides the back button
            .navigationBarItems(trailing: Button("Finish") {
                // Action for Finish button
                print("Finish button tapped")
            })
        }
    }
}

// Preview
struct FlashcardStudyView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardStudyView()
    }
}
