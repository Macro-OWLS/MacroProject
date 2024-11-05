import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case libraryView
        case libraryPhraseCardView(String)
        case levelView
        case levelSelectionPage(Level)
        case studyPhraseView
        case welcomeView
        case signInView
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
        case .signInView:
            SignInView()
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
