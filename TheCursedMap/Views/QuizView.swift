//
//  QuizView.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-20.
//
import SwiftUI
import SwiftData

struct QuizView: View {
    @Environment(\.modelContext) var modelContext // För att skicka till ViewModel
    @Environment(\.dismiss) var dismiss // För att stänga quizvyn

    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8) // Mörk bakgrund för quizzen
                .ignoresSafeArea()

            VStack {
                if viewModel.isLoading { // Om du har en laddningsstatus i ViewModel
                    ProgressView("Laddar frågor...")
                        .foregroundColor(.white)
                } else if viewModel.quizFinished {
                    QuizResultView(score: viewModel.score, totalQuestions: viewModel.allQuizQuestions.count)
                        .padding()
                    Button("Spela igen?") {
                        viewModel.resetQuiz()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding()
                    Button("Stäng") {
                        dismiss() // Stänger den modala vyn
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else if let question = viewModel.currentQuestion {
                    Text(question.questionText)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    ForEach(question.options.indices, id: \.self) { index in
                        Button {
                            viewModel.submitAnswer(optionIndex: index)
                        } label: {
                            Text(question.options[index])
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 5)
                        .disabled(viewModel.showExplanation) // Inaktivera knappar under förklaring
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
                    }

                    Spacer()

                    Text("Poäng: \(viewModel.score) / \(viewModel.currentQuestionIndex)")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                } else {
                    Text("Inga frågor hittades eller laddades.")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .onAppear {
                viewModel.configure(with: modelContext) // Konfigurera ViewModel med ModelContext
            }
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

// MARK: - Preview för QuizView
#Preview {
    QuizView()
        // Konfigurera SwiftData för förhandsvisningen
        .modelContainer(for: QuizQuestion.self, inMemory: true) { container in
            // Seeda quizfrågor för förhandsvisningen
            container.mainContext.insert(QuizQuestion(questionText: "Vad är ett spöke?", options: ["En levande varelse", "En död persons ande", "En sten", "En fågel"], correctAnswerIndex: 1, explanation: "Ett spöke är enligt folktro anden av en avliden person."))
            container.mainContext.insert(QuizQuestion(questionText: "Vilken färg har blodet?", options: ["Grön", "Gul", "Röd", "Blå"], correctAnswerIndex: 2, explanation: "Blod är rött på grund av hemoglobin."))
            container.mainContext.insert(QuizQuestion(questionText: "Vad kallas en grupp fladdermöss?", options: ["Flock", "Svärm", "Koloni", "Hjord"], correctAnswerIndex: 2, explanation: "En grupp fladdermöss kallas en koloni."))
            // Fler frågor för förhandsvisning
        }
}
