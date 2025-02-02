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
   
    
    //@State private var showSettings = false
    let question: Question
    
    
    var body: some View {
        VStack {
            Text(question.text)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Enter answer", text: $userAnswer)
                .keyboardType(.numberPad)
                .padding()
        }
        Button("Submit") {
            
        }
        
        Spacer()
        
        Text("Score: \(score)")
        
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
                        generateQuestions()
                        gameIsEnabled.toggle()
                    }
                    .sheet(isPresented: $gameIsEnabled) {
                        GameView(userAnswer: $userAnswer, score: $score, scoreTitle: $scoreTitle, question: questions.first!)
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
        gameIsEnabled = true
        showResults = false
        score = 0
        generateQuestions()
    }
    
    func generateQuestions() {
        let firstMultiplier = Int.random(in: 1...12)
        let secondMultiplier = Int.random(in: 1...12)
        let answer = "\(firstMultiplier * secondMultiplier)"
        for _ in 0..<totalQuestions {
            questions.append(Question(text: "What is \(firstMultiplier) x \(secondMultiplier)", answer: answer))
        }
        
    }
    
    func submit() {
        for question in questions {
            if question.answer == userAnswer {
                score += 1
            }
        }
        
    }
    
    func resetGame() {
        
    }
}

#Preview {
    ContentView()
}
