//
//  QuizViewModel.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import Foundation
import SwiftData
import SwiftUI

final class QuizViewModel: ObservableObject {
    @Published var currentQuestion: QuizQuestion?
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var quizFinished: Bool = false
    @Published var showExplanation: Bool = false
    @Published var lastAnswerWasCorrect: Bool?

    var allQuizQuestions: [QuizQuestion] = []
    private var modelContext: ModelContext?

    // Konfigurera ViewModel med ModelContext
    func configure(with context: ModelContext) {
        self.modelContext = context
        loadQuestions()
    }

    private func loadQuestions() {
        guard let context = modelContext else {
            print("Error: ModelContext is not set.")
            return
        }
        do {
            let descriptor = FetchDescriptor<QuizQuestion>(sortBy: [SortDescriptor(\.questionText)])
            allQuizQuestions = try context.fetch(descriptor)
            print("Loaded \(allQuizQuestions.count) quiz questions.")
            if allQuizQuestions.isEmpty {
                print("No quiz questions found in database. Please ensure seeding is working.")
            } else {
                startNewQuiz()
            }
        } catch {
            print("Failed to fetch quiz questions: \(error)")
        }
    }

    func startNewQuiz() {
        score = 0
        currentQuestionIndex = 0
        quizFinished = false
        showExplanation = false
        lastAnswerWasCorrect = nil
        // Blanda frågorna för varje nytt quiz 
        allQuizQuestions.shuffle()
        presentNextQuestion()
    }

    private func presentNextQuestion() {
        guard currentQuestionIndex < allQuizQuestions.count else {
            quizFinished = true
            currentQuestion = nil
            return
        }
        currentQuestion = allQuizQuestions[currentQuestionIndex]
        showExplanation = false
        lastAnswerWasCorrect = nil
    }

    func submitAnswer(optionIndex: Int) {
        guard let question = currentQuestion, !showExplanation else { return }

        let isCorrect = (optionIndex == question.correctAnswerIndex)
        lastAnswerWasCorrect = isCorrect
        if isCorrect {
            score += 1
        }
        showExplanation = true

        // Gå till nästa fråga efter en kort fördröjning
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentQuestionIndex += 1
            self.presentNextQuestion()
        }
    }

    func resetQuiz() {
        startNewQuiz()
    }
}
