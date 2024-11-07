//
//  FeatureCardModel.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import Foundation
import SwiftUI

internal struct FeatureCardType: Equatable, Hashable {
    let id: String
    let backgroundColor: Color
    let icon: String
    let title: String
    let description: String
//    let onTap: () -> Void?
}
