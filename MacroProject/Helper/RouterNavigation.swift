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
    
    @ViewBuilder
    func viewToDisplay(router: Router<NavigationRoute>) -> some View {
        switch self {
        case .libraryView:
            LibraryView(router: router, viewModel: TopicViewModel(useCase: TopicUseCase(repository: TopicRepository())))
        case .libraryPhraseCardView(let topicID):
            LibraryPhraseCardView(viewModel: PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository())), router: router, topicID: topicID)
        }
    }
    
    var navigationType: NavigationType {
        switch self {
        case .libraryView:
            return .push
        case .libraryPhraseCardView(_):
            return .push
        }
    }
}



