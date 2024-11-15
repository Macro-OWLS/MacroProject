//
//  LoadingView.swift
//  MacroProject
//
//  Created by Agfi on 15/11/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Color(Color.cream)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 28, content: {
                Image("CapybaraLoading")
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .brown))
                    .scaleEffect(2.0)
                Text("Please wait while we get our \n Capybara in line")
                    .foregroundColor(.brown)
                    .font(.poppinsB1)
                    .multilineTextAlignment(.center)
                    .fontWeight(.medium)
            })
        })
    }
}

#Preview {
    LoadingView()
}
