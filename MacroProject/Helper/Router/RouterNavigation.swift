import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case libraryView
        case libraryPhraseCardView(String)
        case levelView
        case levelSelectionPage(Level)
        case studyPhraseView
        case welcomeView
        case authenticationView
        case signInView
        case signUpView
        case oldSignInView
    }
    
    @Published var path = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .libraryView:
            LibraryView()
        case .libraryPhraseCardView(let topicID):
            LibraryPhraseCardView(topicID: topicID)
        case .levelView:
            LevelPage()
        case .levelSelectionPage(let level):
            LevelSelectionPage(level: level)
        case .studyPhraseView:
            StudyPhraseView()
        case .welcomeView:
            WelcomeView()
        case .authenticationView:
            AuthenticationView()
        case .signInView:
            SignInView(currentView: .constant(.signIn))
        case .signUpView:
            SignUpView(currentView: .constant(.signUp))
        case .oldSignInView:
            OldSignInView()
        }
    }
    
    func navigateTo(_ route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
