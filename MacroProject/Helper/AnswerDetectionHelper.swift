//
//  AnswerDetectionHelper.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 16/10/24.
//

import Foundation

class AnswerDetectionHelper {
    func isAnswerCorrect(userInput: String, correctAnswer: String) -> Bool {
        return userInput.lowercased() == correctAnswer.lowercased() // Example logic
    }
}
