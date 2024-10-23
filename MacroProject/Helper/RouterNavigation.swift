//
//  RouterNavigation.swift
//  MacroProject
//
//  Created by Ages on 13/10/24.
//
import SwiftUI
import Routing

enum NavigationRoute: Routable, Hashable {
    case libraryView
    case libraryPhraseCardView(String)
    case levelView(Binding<TabViewType>)
    case levelSelectionPage(Level, Binding<TabViewType>)

    @ViewBuilder
    func viewToDisplay(router: Router<NavigationRoute>) -> some View {
        switch self {
        case .libraryView:
            LibraryView(router: router)
        case .libraryPhraseCardView(let topicID):
            LibraryPhraseCardView(viewModel: PhraseCardViewModel(), topicViewModel: TopicViewModel(), router: router, topicID: topicID)
        case .levelView(let selectedTabView):
            LevelPage(router: router, selectedTabView: selectedTabView)
        case .levelSelectionPage(let level, let selectedTabView):
            LevelSelectionPage(router: router, level: level, selectedView: selectedTabView)
        }
    }

    var navigationType: NavigationType {
        switch self {
        case .libraryView, .libraryPhraseCardView, .levelView, .levelSelectionPage:
            return .push
        }
    }

    // Manually conforming to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .libraryView:
            hasher.combine("libraryView")
        case .libraryPhraseCardView(let topicID):
            hasher.combine("libraryPhraseCardView")
            hasher.combine(topicID)
        case .levelView:
            hasher.combine("levelView") // Ignoring Binding<TabViewType>
        case .levelSelectionPage(let level, _):
            hasher.combine("levelSelectionPage")
            hasher.combine(level) // Ignoring TabViewType
        }
    }

    // Manually conforming to Equatable
    static func ==(lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.libraryView, .libraryView):
            return true
        case (.libraryPhraseCardView(let lhsID), .libraryPhraseCardView(let rhsID)):
            return lhsID == rhsID
        case (.levelView, .levelView):
            return true // Don't compare Bindings directly
        case (.levelSelectionPage(let lhsLevel, _), .levelSelectionPage(let rhsLevel, _)):
            return lhsLevel == rhsLevel // Compare Level, ignore selectedTabView
        default:
            return false
        }
    }
}
