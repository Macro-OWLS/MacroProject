//
//  AnswerDetectionModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 15/10/24.
//

import Foundation

class AnswerDetectionModel {
    func isAnswerCorrect(userInput: String, correctAnswer: String) -> Bool {
        return userInput.lowercased() == correctAnswer.lowercased()
    }
}
