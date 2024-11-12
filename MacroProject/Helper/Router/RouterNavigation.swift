import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case studyView
        case studyPhraseCardView(String)
        case levelView
        case levelSelectionPage(Level)
        case reviewPhraseView
        case recapView
        case reviewRecapView
        case welcomeView
        case authenticationView
        case signInView
        case signUpView
        case oldSignInView
        case homeView
        case profileView
    }
    
    @Published var path = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .studyView:
            StudyView()
        case .studyPhraseCardView(let topicID):
            StudyPhraseCardView(topicID: topicID)
        case .levelView:
            LevelPage()
        case .levelSelectionPage(let level):
            LevelSelectionPage(level: level)
        case .reviewPhraseView:
            ReviewPhraseView()
        case .recapView:
            RecapView()
        case .reviewRecapView:
            RecapPhrasesView()
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
        case .homeView:
            HomeView()
        case .profileView:
            ProfileView()
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
