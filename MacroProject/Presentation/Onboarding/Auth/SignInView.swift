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
            
            VStack(spacing: 14, content: {
                BubbleChat(text: "Masuk dengan Akunmu!")
                    .offset(x: -85, y: 5)
                Image("CapybaraAuth")
            })
            .offset(x: 120, y: -190)
            VStack(alignment: .center, spacing: 16) {
                InputComponent(input: InputType(title: "Email", placeholder: "Email", value: $onboardingViewModel.userRegisterInput.email))
                InputComponent(input: InputType(title: "Password", placeholder: "Password", value: $onboardingViewModel.userRegisterInput.password))
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
                    } else {
                        Text("Buat Akun")
                    }
                }
                .frame(width: 225, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top, 16)
                
                if let errorMessage = onboardingViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                HStack(alignment: .center, spacing: 4, content: {
                    Text("Don't have an Account?")
                        .foregroundColor(.grey)
                    Button("Register Here!") {
                        currentView = .signUp
                    }
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                })
            }
            .offset(y: -7)
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    SignInView(currentView: .constant(.signIn))
        .environmentObject(OnboardingViewModel())
}
