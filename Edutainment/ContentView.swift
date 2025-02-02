//
//  ContentView.swift
//  Edutainment
//
//  Created by Kristina Kostenko on 20.01.2025.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var userAnswer: String
    @Binding var score: Int
    @Binding var scoreTitle: String
    @Binding var showResults: Bool
    var generateNextQuestion: () -> Void
    @Binding var showingFinalScore: Bool
    var resetGame: () -> Void
    var submit: () -> Void
   
    
    //@State private var showSettings = false
    let question: Question
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(question.text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary) //auto-adjustment for the system color mode
                .padding()

            
            TextField("Enter answer", text: $userAnswer)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.primary)
                .padding()
            
            Button("Submit") {
                submit()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
            
            Spacer()
            
            Text("Score: \(score)")
                .font(.headline)
                .padding(.bottom, 20)
        }
        
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))//auto-adjustment for the system color mode
        .alert(scoreTitle, isPresented: $showResults) {
            Button("Continue", action: generateNextQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over!", isPresented: $showingFinalScore) {
            Button("Reset", action: resetGame)
        } message: {
            Text("Final score is \(score)")
        }
    }
}


struct Question {
    var text: String
    var answer: String
}


struct ContentView: View {
    //showingSettings
    @State private var gameIsEnabled = false
    @State private var showResults = false
    @State private var selectedTables = 2
    @State private var totalQuestions = 5
    @State private var score = 0
    @State private var userAnswer = ""
    @State private var questions: [Question] = []
    @State private var scoreTitle = ""
    @State private var showingFinalScore = false
    @State private var currentQuestionIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Multiplication table range") {
                    Stepper("Up to \(selectedTables)", value: $selectedTables, in: 2...12, step: 1)
                }
                Section("Questions count") {
                    Picker("questions", selection: $totalQuestions) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("20").tag(20)
                    }
                    .pickerStyle(.segmented)
                }
                HStack {
                    Spacer()
                    Button("Start game") {
                        startGame()
                    
                    }
                    .sheet(isPresented: $gameIsEnabled) {
                        if currentQuestionIndex < questions.count {
                            GameView(
                                userAnswer: $userAnswer,
                                score: $score,
                                scoreTitle: $scoreTitle,
                                showResults: $showResults,
                                generateNextQuestion: generateNextQuestion,
                                showingFinalScore:$showingFinalScore,
                                resetGame: resetGame,
                                submit: submit,
                                question: questions[currentQuestionIndex])
                        } else {
                            Text("No questions available")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
            .navigationTitle("Edutainment")
        }
        
    }
    func startGame() {
        generateQuestions()
        showResults = false
        score = 0
        if !questions.isEmpty {
            currentQuestionIndex = 0
            gameIsEnabled = true
            
        }
    }
    
    func generateQuestions() {
        questions.removeAll()
        for _ in 0..<totalQuestions {
        let firstMultiplier = Int.random(in: 1...selectedTables)
        let secondMultiplier = Int.random(in: 1...12)
        let answer = "\(firstMultiplier * secondMultiplier)"
        
            questions.append(Question(text: "What is \(firstMultiplier) x \(secondMultiplier)", answer: answer))
        }
        
    }
    
    func submit() {
        guard currentQuestionIndex < questions.count else { return }
        let correctAnswer = questions[currentQuestionIndex].answer
        if userAnswer == correctAnswer {
                scoreTitle = "Correct"
                score += 1
            } else {
                scoreTitle = "Wrong! The correct answer is \(correctAnswer)"
            }
            
        userAnswer = ""
            
        if currentQuestionIndex == totalQuestions - 1 {
                showingFinalScore = true
            } else {
                showResults = true
                
            }
        
    }
    
    func generateNextQuestion() {
        if currentQuestionIndex < totalQuestions - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func resetGame() {
        score = 0
        currentQuestionIndex = 0
        startGame()
        
    }
}

#Preview {
    ContentView()
}
