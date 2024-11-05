//
//  OldSignInView.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import SwiftUI

struct OldSignInView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack(alignment: .center, content: {
            Color(Color.cream)
                .ignoresSafeArea()
            
            Circle()
                .frame(width: 328, height: 328)
                .foregroundColor(.blue)
                .clipShape(Rectangle().path(in: CGRect(x: 0, y: 0, width: 328, height: 180)))
            VStack(spacing: -30, content: {
                Image("WhoIsYourNameSignIn")
                    .offset(x: 25)
                Image("SignInCapybara")
            })
            .offset(x: 20, y: -60)
            VStack(alignment: .center, spacing: 48, content: {
                TextField("Username", text: $onboardingViewModel.name)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                
                Button(action: {
                    onboardingViewModel.isAuthenticated = true
                    router.popToRoot()
                }) {
                    Text("Simpan")
                        .padding(.horizontal, 46)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            })
            .offset(y: 80)
        })
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OldSignInView()
}
