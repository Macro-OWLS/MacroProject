//
//  ReviewRecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct ReviewRecapView: View {

    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
//                ForEach(viewmModel.phraseCards, id: \.self) { phrase in
//                    
//                }
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .navigationTitle("Review Recap")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ReviewRecapView()
}
