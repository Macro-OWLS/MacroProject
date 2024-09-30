//
//  Category.swift
//  MacroProject
//
//  Created by Agfi on 30/09/24.
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: String
    var name: String
    var desc: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}
