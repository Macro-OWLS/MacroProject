//
//  ConfirmationAlertType.swift
//  MacroProject
//
//  Created by Agfi on 15/11/24.
//

import Combine
import SwiftUI

struct ConfirmationAlertType {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var confirmAction: () -> Void
    var dismissAction: () -> Void
}
