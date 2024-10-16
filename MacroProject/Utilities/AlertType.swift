//
//  AlertType.swift
//  MacroProject
//
//  Created by Agfi on 16/10/24.
//

import Foundation
import SwiftUI

struct AlertType {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var dismissAction: () -> Void
}
