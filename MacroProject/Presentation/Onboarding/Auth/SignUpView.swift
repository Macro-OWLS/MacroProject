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
            
            VStack(spacing: 14, content: {
                BubbleChat(text: "Ayo Buat Akunmu!")
                    .offset(x: -120, y: 0)
                Image("CapybaraAuth")
            })
                .offset(x: 120, y: -190)
            VStack(alignment: .center, spacing: 16) {
                InputComponent(input: InputType(title: "Name", placeholder: "John Doe", value: $onboardingViewModel.userRegisterInput.fullName))
                InputComponent(input: InputType(title: "Email", placeholder: "vocapy@mail.com", value: $onboardingViewModel.userRegisterInput.email))
                InputComponent(input: InputType(title: "Password", placeholder: "* * * * * * * * * *", value: $onboardingViewModel.userRegisterInput.password))
                Button(action: {
                    Task {
                        do {
                            try await onboardingViewModel.register()
                            if onboardingViewModel.errorMessage == nil {
                                currentView = .signIn
                            }
                        } catch {
                            currentView = .signUp
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
                
                HStack(alignment: .center, spacing: 4, content: {
                    Text("Sudah punya akun?")
                        .foregroundColor(.darkGrey)
                    Button("Login Disini!") {
                        currentView = .signIn
                        onboardingViewModel.errorMessage = nil
                    }
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                })
                
                if let errorMessage = onboardingViewModel.errorMessage {
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "x.circle.fill")
                        Text(errorMessage)
                    }
                    .foregroundColor(.red)
                    .padding(.top, 10)
                }
            }
            .offset(y: 40)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpView(currentView: .constant(.signUp))
        .environmentObject(OnboardingViewModel())
}
