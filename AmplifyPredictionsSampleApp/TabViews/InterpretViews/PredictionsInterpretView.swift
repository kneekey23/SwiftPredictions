//
//  PredictionsInterpretView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI
import Amplify

struct PredictionsInterpretView: View {
    
    @State private var userInput: String = ""
    @State private var sentiment: String = ""
    @State private var language: String = ""
    @State private var syntaxTokens = [SyntaxToken]()
    
    func interpret(text: String) {
        
        _ = Amplify.Predictions.interpret(text: text, options: PredictionsInterpretRequest.Options(), listener: { (event) in
               
               switch event {
               case .completed(let result):
                   print(result)
                   self.setResults(data: result)
               case .failed(let error):
                print(error)
               default:
                break
            }
           })
    }
    
    func setResults(data: InterpretResult) {
        if let sentimentResult = data.sentiment?.predominantSentiment {
            self.sentiment = sentimentResult.rawValue
        }
        if let languageResult = data.language {
            self.language = languageResult.languageCode.rawValue
        }
        if let tokens = data.syntax {
        for token in tokens {
            let newToken = SyntaxToken(id: UUID(), text: token.text, partofSpeech: token.partOfSpeech.tag.rawValue, score: Double(token.partOfSpeech.score ?? 0.0) * 100)
            syntaxTokens.append(newToken)
        }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text to interpret", text: $userInput)
                    .padding(.all)
                Button(action: {
                    self.interpret(text: self.userInput)
                }) {
                    HStack {
                        Spacer()
                        Text("Interpret")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding(.vertical, 10.0)
                .background(Color.blue)
                .padding(.horizontal, 50)
                Text("Sentiment: " + sentiment).padding(.all)
                Text("Language: " +  language).padding(.all)
                List(syntaxTokens, id: \.id) {token in
                    SyntaxRow(token: token)
                }.listStyle(GroupedListStyle())
            }.navigationBarTitle(Text("Interpret"))
        }
    }
}

