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
            
            if onboardingViewModel.isLoading {
                ProgressView()
            } else {
                VStack(spacing: 14, content: {
                    BubbleChat(text: "Masuk dengan Akunmu!")
                        .offset(x: -150, y: 0)
                    Image("CapybaraAuth")
                })
                .offset(x: 120, y: -190)
                VStack(alignment: .center, spacing: 16) {
                    InputComponent(input: InputType(title: "Email", placeholder: "vocapy@mail.com", value: $onboardingViewModel.userRegisterInput.email))
                    InputComponent(input: InputType(title: "Password", placeholder: "* * * * * * * * * *", value: $onboardingViewModel.userRegisterInput.password))
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
                            Text("Masuk")
                        }
                    }
                    .frame(width: 225, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.top, 16)
                    
                    HStack(alignment: .center, spacing: 4, content: {
                        Text("Belum punya akun?")
                            .foregroundColor(.darkGrey)
                        Button("Buat akun disini!") {
                            currentView = .signUp
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
                .offset(y: -7)
            }
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    SignInView(currentView: .constant(.signIn))
        .environmentObject(OnboardingViewModel())
}
