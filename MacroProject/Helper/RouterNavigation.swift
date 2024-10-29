import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case libraryView
        case libraryPhraseCardView(String)
        case levelView(Binding<TabViewType>)
        case levelSelectionPage(Level, Binding<TabViewType>)
        case studyPhraseView
        
        static func ==(lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.libraryView, .libraryView):
                return true
            case (.libraryPhraseCardView(let lhsID), .libraryPhraseCardView(let rhsID)):
                return lhsID == rhsID
            case (.levelView, .levelView):
                return true
            case (.levelSelectionPage(let lhsLevel, _), .levelSelectionPage(let rhsLevel, _)):
                return lhsLevel == rhsLevel
            case (.studyPhraseView, .studyPhraseView):
                return true
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .libraryView:
                hasher.combine("libraryView")
            case .libraryPhraseCardView(let topicID):
                hasher.combine("libraryPhraseCardView")
                hasher.combine(topicID)
            case .levelView:
                hasher.combine("levelView")
            case .levelSelectionPage(let level, _):
                hasher.combine("levelSelectionPage")
                hasher.combine(level)
            case .studyPhraseView:
                hasher.combine("studyPhraseView")
            }
        }
    }
    
    @Published var path = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .libraryView:
            LibraryView()
        case .libraryPhraseCardView(let topicID):
            LibraryPhraseCardView(topicID: topicID)
        case .levelView(let selectedTabView):
            LevelPage(selectedTabView: selectedTabView)
        case .levelSelectionPage(let level, let selectedTabView):
            LevelSelectionPage(selectedView: selectedTabView, level: level)
        case .studyPhraseView:
            StudyPhraseView()
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
