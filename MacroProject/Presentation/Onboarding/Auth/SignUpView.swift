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
                    .offset(x: -85, y: 5)
                Image("CapybaraAuth")
            })
                .offset(x: 120, y: -190)
            VStack(alignment: .center, spacing: 16) {
                InputComponent(input: InputType(title: "Name", placeholder: "Tulis Namamu Disini...", value: $onboardingViewModel.userRegisterInput.fullName))
                InputComponent(input: InputType(title: "Email", placeholder: "Email", value: $onboardingViewModel.userRegisterInput.email))
                InputComponent(input: InputType(title: "Password", placeholder: "Password", value: $onboardingViewModel.userRegisterInput.password))
                Button(action: {
                    Task {
                        do {
                            try await onboardingViewModel.register()
                            currentView = .signIn
                        } catch {
                            currentView = .signUp
                        }
                    }
                }) {
                    if onboardingViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Register")
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
                    Text("Already have an account?")
                        .foregroundColor(.grey)
                    Button("Login Here!") {
                        currentView = .signIn
                    }
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                })
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

struct InputType {
    var title: String
    var placeholder: String
    var value: Binding<String>
}

struct InputComponent: View {
    var input: InputType
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Text(input.title)
                .font(.poppinsB1)
            if input.title == "Password" {
                SecureField(input.placeholder, text: input.value)
                    .font(.poppinsB2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.offwhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.lightBrown, lineWidth: 1)
                    )
            } else {
                TextField(input.placeholder, text: input.value)
                    .font(.poppinsB2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.offwhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.lightBrown, lineWidth: 1)
                    )
            }
        })
        .padding(.horizontal, 16)
    }
}

struct BubbleChat: View {
    var text: String
    var body: some View {
        VStack(alignment: .trailing, spacing: -5) {
            Text(text)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brown)
                .cornerRadius(15)
                .foregroundColor(.white)
                .font(.poppinsH3)
            Image("Chat")
                .offset(x: -15)
        }
    }
}
