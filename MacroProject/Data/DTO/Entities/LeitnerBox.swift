//
//  LeitnerBox.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation
import SwiftData

@Model
final class LeitnerBox {
    var id: String
    var userLibraryDeck: UserLibraryDeck
    var phraseCard: PhraseCard
}
