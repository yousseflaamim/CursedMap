//
//  QuizView.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import SwiftUI

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: QuizViewModel
    
    let quizQuestion: QuizQuestion

    init(question: QuizQuestion, treasureVM: TreasureViewModel) {
        self.quizQuestion = question
        _viewModel = StateObject(wrappedValue: QuizViewModel(question: question, treasureVM: treasureVM))
    }

    var body: some View {
        ZStack {
            Color("GrayBlack")
                .ignoresSafeArea()

            if viewModel.showTreasureRewardView {
                TreasureRewardView(dismissAction: {
                    viewModel.showTreasureRewardView = false
                    dismiss()
                })
                .transition(.scale.animation(.spring()))
                .zIndex(1)
            } else {
                VStack {
                    if let question = viewModel.currentQuestion {
                        Text(question.questionText)
                            .font(.title2)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)

                        ForEach(question.options.indices, id: \.self) { index in
                            Button(action: { // Explicita action-parametern
                                viewModel.submitAnswer(optionIndex: index)
                            }, label: { // Explicita label-parametern
                                Text(question.options[index])
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }) // Avslutande parentes för Button-init
                            .padding(.bottom, 5)
                            .disabled(viewModel.showExplanation)
                        }


                        if viewModel.showExplanation {
                            if let wasCorrect = viewModel.lastAnswerWasCorrect {
                                Text(wasCorrect ? "Rätt svar!" : "Fel svar!")
                                    .font(.title3)
                                    .foregroundColor(wasCorrect ? .green : .red)
                                    .padding(.top, 10)
                            }
                            if let explanation = question.explanation, !explanation.isEmpty {
                                Text(explanation)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                            }
                            
                            if !viewModel.showWrongAnswerView {
                                Button("Stäng") {
                                    dismiss()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)
                                .padding(.top, 20)
                            }
                        }
                    } else {
                        Text("Ingen fråga hittades för denna kista.")
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showWrongAnswerView) {
            WrongAnswerView(dismissAction: {
                viewModel.showWrongAnswerView = false
                dismiss()
            })
        }
    }
}

// Liten hjälpvy för att visa quizresultatet
struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int

    var body: some View {
        VStack {
            Text("Quiz avklarat!")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Din poäng: \(score) av \(totalQuestions)")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top, 10)
        }
        .padding()
        .background(Color.purple.opacity(0.8))
        .cornerRadius(15)
    }
}

