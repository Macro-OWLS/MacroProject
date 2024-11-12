//
//  AuthenticationView.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import SwiftUI

enum AuthenticatioView {
    case signUp
    case signIn
}

struct AuthenticationView: View {
    @State private var currentView: AuthenticatioView = .signIn
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        switch currentView {
        case .signIn:
            SignInView(currentView: $currentView)
        case .signUp:
            SignUpView(currentView: $currentView)
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(OnboardingViewModel())
}
