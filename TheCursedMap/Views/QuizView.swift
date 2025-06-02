//
//  QuizView.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    let dismissAction: () -> Void

    init(question: QuizQuestion, treasureVM: TreasureViewModel, dismissAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(question: question, treasureVM: treasureVM))
        self.dismissAction = dismissAction
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            if viewModel.showTreasureRewardView {
                TreasureRewardView(dismissAction: {
                    viewModel.showTreasureRewardView = false
                    dismissAction()
                })
                .transition(.opacity)
                .zIndex(1)
            } else if let question = viewModel.currentQuestion {
                Image("QuizMap")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 380)
                    .overlay(
                        VStack(spacing: 16) {
                            Text(question.questionText)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            ForEach(question.options.indices, id: \.self) { index in
                                Button {
                                    viewModel.submitAnswer(optionIndex: index)
                                } label: {
                                    Text(question.options[index])
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.black.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(viewModel.showExplanation)
                            }
                            
                            if viewModel.showExplanation {
                                if let wasCorrect = viewModel.lastAnswerWasCorrect {
                                    Text(wasCorrect ? "Rätt svar!" : "Fel svar!")
                                        .font(.title3)
                                        .foregroundColor(wasCorrect ? .green : .red)
                                }
                                
                                if let explanation = question.explanation, !explanation.isEmpty {
                                    Text(explanation)
                                        .font(.caption)
                                        .foregroundColor(.black.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                if !viewModel.showWrongAnswerView {
                                    Button("Stäng") {
                                        dismissAction()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    .padding(.top, 5)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Text("Ingen fråga hittades för denna kista.")
                        .foregroundColor(.white)
                    }
                }
        .animation(.easeInOut, value: viewModel.showExplanation)
        .fullScreenCover(isPresented: $viewModel.showWrongAnswerView) {
            WrongAnswerView(dismissAction: {
                viewModel.showWrongAnswerView = false
                dismissAction()
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

