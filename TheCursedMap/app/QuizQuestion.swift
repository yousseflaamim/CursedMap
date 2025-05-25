//
//  QuizQuestion.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    var questionText: String
    var options: [String]
    var correctAnswerIndex: Int
    var explanation: String?

    init(questionText: String, options: [String], correctAnswerIndex: Int, explanation: String? = nil) {
        self.questionText = questionText
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
    }
}
