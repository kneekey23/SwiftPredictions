//
//  PredictionsInterpretView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Roy, Jithin on 10/23/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI
import Amplify
import AVKit

struct PredictionsConvertView: View {

    @State private var userInput: String = ""
    @State private var translatedText: String = ""
    @State private var showingConvertActionSheet = false
    @State private var avPlayer: AVAudioPlayer!

    func translateText(text:String) {
        _ = Amplify.Predictions.convert(textToTranslate: text,
                                        language: .english,
                                        targetLanguage: .italian,
                                        options: PredictionsTranslateTextRequest.Options(),
                                        listener: { (event) in
                                            
                                            switch event {
                                            case .completed(let result):
                                                print(result.text)
                                                self.translatedText = result.text
                                            default:
                                                print("")
                                                
                                                
                                            }
        })
    }
    
    func textToSpeech(text: String) {
        let options = PredictionsTextToSpeechRequest.Options(voiceType: .englishFemaleIvy, pluginOptions: nil)
     
        _ = Amplify.Predictions.convert(textToSpeech: text, options: options, listener: { (event) in
            
            switch event {
            case .completed(let result):
                print(result.audioData)
                self.avPlayer = try? AVAudioPlayer(data: result.audioData)
                self.avPlayer?.play()
            default:
                print("")
                
                
            }
        })
    }
    
    var convertActionSheet: ActionSheet {
        ActionSheet(title: Text("Action Sheet"), message: Text("Choose Option"), buttons: [
            .default(Text("Translate Text"), action: {self.translateText(text: self.userInput)}),
            .default(Text("Text to Speech"), action: {self.textToSpeech(text: self.userInput)}),
            .destructive(Text("Cancel"))
        ])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text to convert", text: $userInput)
                    .padding(.all)
                Button(action: {
                    self.showingConvertActionSheet.toggle()
                }) {
                    HStack {
                        Spacer()
                        Text("Convert")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 10.0)
                .background(Color.blue)
                .padding(.horizontal, 50)
                Text(translatedText).padding(.all)
                
            }.padding(.horizontal, 15)
                .actionSheet(isPresented: $showingConvertActionSheet, content: {
                    self.convertActionSheet
                })
                .navigationBarTitle(Text("Convert"))
        }
    }
    
}

struct PredictionsConvertView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsConvertView()
        .padding()
    }
}
