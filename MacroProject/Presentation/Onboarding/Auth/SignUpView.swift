//
//  SignUpView.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Binding var currentView: AuthenticatioView

    var body: some View {
        ZStack(alignment: .center) {
            Color(Color.cream)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16) {
                TextField("Full Name", text: $onboardingViewModel.userRegisterInput.fullName)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                
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
                        try await onboardingViewModel.register()
                        currentView = .signIn
                    }
                }) {
                    if onboardingViewModel.isLoading {
                        ProgressView()
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    } else {
                        Text("Sign Up")
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
                
                Button("Already have an account? Sign In") {
                    currentView = .signIn
                }
                .foregroundColor(.blue)
            }
            .offset(y: 80)
        }
        .navigationBarBackButtonHidden()
    }
}
