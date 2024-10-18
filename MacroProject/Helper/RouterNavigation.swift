//
//  RouterNavigation.swift
//  MacroProject
//
//  Created by Ages on 13/10/24.
//
import SwiftUI
import Routing

enum NavigationRoute: Routable {
    case libraryView
    case libraryPhraseCardView(String)
//    case studyPhraseCardView
//    case recapReviewView
    case levelView
    case levelSelectionPage(Level)
//    case recapView
    
    @ViewBuilder
    func viewToDisplay(router: Router<NavigationRoute>) -> some View {
        switch self {
        case .libraryView:
            LibraryView(router: router, viewModel: TopicViewModel(useCase: TopicUseCase(repository: TopicRepository())))
        case .libraryPhraseCardView(let topicID):
            LibraryPhraseCardView(viewModel: PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository())), topicViewModel: TopicViewModel(useCase: TopicUseCase(repository: TopicRepository())), router: router, topicID: topicID)
        case .levelView:
            LevelPage(router: router)
        case .levelSelectionPage(let level):
            LevelSelectionPage(router: router, level: level, selectedView: .constant(.library))
        }
    }
    
    var navigationType: NavigationType {
        switch self {
        case .libraryView, .libraryPhraseCardView, .levelView, .levelSelectionPage:
            return .push
        }
    }
}
