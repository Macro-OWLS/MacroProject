//
//  SignInView.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Binding var currentView: AuthenticatioView
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(Color.cream)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16) {
                TextField("Email", text: $onboardingViewModel.userRegisterInput.email)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                
                SecureField("Password", text: $onboardingViewModel.userRegisterInput.password)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                
                Button(action: {
                    Task {
                        try await onboardingViewModel.signIn()
                        if onboardingViewModel.isAuthenticated {
                            router.popToRoot()
                        }
                    }
                }) {
                    if onboardingViewModel.isLoading {
                        ProgressView()
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    } else {
                        Text("Sign In")
                            .padding(.horizontal, 46)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                
                if let errorMessage = onboardingViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Button("Don't have an account? Sign Up") {
                    currentView = .signUp
                }
                .foregroundColor(.blue)
            }
            .offset(y: 80)
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    SignInView(currentView: .constant(.signIn))
}
