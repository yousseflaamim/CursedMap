//
//  QuizViewModel.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import Foundation
import SwiftUI

final class QuizViewModel: ObservableObject {
    
    @Published var currentQuestion: QuizQuestion?
    @Published var showExplanation: Bool = false
    @Published var lastAnswerWasCorrect: Bool?
    @Published var showWrongAnswerView: Bool = false
    
    @Published var treasureVM: TreasureViewModel? = nil // to update levelprogress in firestore
    

    init(treasureVM: TreasureViewModel? = nil) { // also to update levelprogress in firestore
           self.treasureVM = treasureVM
          // loadQuestions()
       }
    

    static let predefinedQuestions: [QuizQuestion] = [

        QuizQuestion(questionText: "Vilken färg har blodet?", options: ["Grön", "Gul", "Röd", "Blå"], correctAnswerIndex: 2, explanation: "Blod är rött på grund av hemoglobin och järn."),
        QuizQuestion(questionText: "Vilket organ pumpar blod?", options: ["Levern", "Lungorna", "Hjärtat", "Njuren"], correctAnswerIndex: 2, explanation: "Hjärtat är en muskel som pumpar blod genom kroppen."),
        QuizQuestion(questionText: "Vad heter den fiktiva karaktären som bor i en kista?", options: ["Drakula", "Frankenstein", "Jack Sparrow", "Spöket Laban"], correctAnswerIndex: 3, explanation: "Spöket Laban är en vänlig karaktär som bor i ett linneskåp i ett slott."),
        QuizQuestion(questionText: "Vad kallas en grupp fladdermöss?", options: ["Flock", "Svärm", "Koloni", "Hjord"], correctAnswerIndex: 2, explanation: "En grupp fladdermöss kallas en koloni."),
        QuizQuestion(questionText: "Vem skrev Frankenstein?", options: ["Mary Shelley", "Bram Stoker", "Edgar Allan Poe", "H.P. Lovecraft"], correctAnswerIndex: 0, explanation: "Mary Shelley publicerade Frankenstein 1818."),
        QuizQuestion(questionText: "Vad är en 'banshee' enligt irländsk folktro?", options: ["En god fe", "Ett kvinnligt spöke som varslar döden", "En typ av älva", "En skogsvarelse"], correctAnswerIndex: 1, explanation: "En banshee är ett kvinnligt andeväsen som varslar döden genom att skrika eller jämra sig.")
    ]
    
    init(question: QuizQuestion, treasureVM: TreasureViewModel?) {
        self.currentQuestion = question
        self.treasureVM = treasureVM
    }
    
    func submitAnswer(optionIndex: Int) {
        guard let question = currentQuestion, !showExplanation else { return }

        let isCorrect = (optionIndex == question.correctAnswerIndex)
        lastAnswerWasCorrect = isCorrect
        if isCorrect {
            treasureVM?.openChest() // opens chest in treasureViewModel to save to firestore
        } else {
            showWrongAnswerView = true
        }
        showExplanation = true

        // Gå till nästa fråga efter en kort fördröjning
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         //   self.currentQuestionIndex += 1
          //  self.presentNextQuestion()
        }
  //  }

  //  func resetQuiz() {
   //     startNewQuiz()
   // }

}
