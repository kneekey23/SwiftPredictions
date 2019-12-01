//
//  PredictionsIdentifyView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/5/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import Foundation
import SwiftUI
import Amplify

struct PredictionsIdentifyView: View {
    
    @State private var resultLabels = [IdentifyLabel]()
    @State private var resultLines = [Line]()
    @State private var resultEntities = [IdentifiedEntity]()
    @State var showingPicker = false
    @State var image: Image? = nil
    @State var uiimage: UIImage? = nil
    @State var imageUrl: URL? = nil
    @State private var showingActionSheet = false
    @State var celebName: String? = ""
    @State var unsafeContent: String? = ""
   
    func detectLabels(_ image:URL) {
        
        let options = PredictionsIdentifyRequest.Options(defaultNetworkPolicy: .auto, pluginOptions: nil)
        _ = Amplify.Predictions.identify(type: .detectLabels(.labels), image: image, options: options, listener: { (event) in
            
            switch event {
            case .completed(let result):
                let data = result as! IdentifyLabelsResult
                self.setNewLabels(result: data)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
    
    func setNewLabels(result: IdentifyLabelsResult) {
        //clear old results before setting new results
        clearOldResults()
      
        for label in result.labels {
            let newLabel = IdentifyLabel(id: UUID(), name: label.name, confidence: label.metadata?.confidence ?? 0.0)
            resultLabels.append(newLabel)
        }
        
        if let unsafeContentUnwrapped = result.unsafeContent {
            unsafeContent = unsafeContentUnwrapped ? "There is unsafe content in this image" : "This content is safe."
        }
    }
    
    func setNewText(result: IdentifyTextResult) {
        clearOldResults()
        guard let identifiedLines = result.identifiedLines else {
            return
        }
        for line in identifiedLines {
           // let rect = convert(ratio: line.boundingBox)
            let newLine = Line(id: UUID(), text: line.text, boundingBox: line.boundingBox)
            resultLines.append(newLine)
        }
    }
    
    func setNewEntities(result: IdentifyEntitiesResult) {
        clearOldResults()

        for entity in result.entities {
            print(entity)
            
            let newEntity = IdentifiedEntity(id: UUID(), boundingBox: entity.boundingBox, ageRange: entity.ageRange ?? nil, gender: entity.gender ?? nil)
            resultEntities.append(newEntity)
            
        }
    }
    
    func clearOldResults(){
        resultLabels.removeAll()
        resultLines.removeAll()
        resultEntities.removeAll()
        unsafeContent = ""
        celebName = ""
    }
    
    func detectCelebs(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectCelebrity, image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyCelebritiesResult
                self.clearOldResults()
                if !data.celebrities.isEmpty {
                    self.celebName = data.celebrities[0].metadata.name
                }
                print(result)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
    
    func detectEntities(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectEntities, image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyEntitiesResult
                self.clearOldResults()
                self.setNewEntities(result: data)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }

    func detectText(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectText(.plain), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyTextResult
                self.setNewText(result: data)
                print(data)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Action Sheet"), message: Text("Choose Option"), buttons: [
            .default(Text("Detect Labels"), action: {self.detectLabels(self.imageUrl!)}),
            .default(Text("Detect Celebrities"), action: {self.detectCelebs(self.imageUrl!)}),
            .default(Text("Detect Entities"), action: {self.detectEntities(self.imageUrl!)}),
            .default(Text("Detect Text"), action: {self.detectText(self.imageUrl!)}),
            .destructive(Text("Cancel"))
        ])
    }
    

    var list: AnyView {
        if !resultLabels.isEmpty {
            return AnyView(List(resultLabels, id: \.id) {label in
                LabelRow(label: label)
            }.listStyle(GroupedListStyle()))
        }
        else if !resultLines.isEmpty {
            return AnyView(List(resultLines, id: \.id) {line in
                TextRow(line: line, image: self.uiimage!)
            }.listStyle(GroupedListStyle()))
        }
        if !resultEntities.isEmpty {
            return AnyView(List(resultEntities, id: \.id){entity in
                EntityRow(image: self.uiimage!, entity: entity)
            }.listStyle(GroupedListStyle()))
        }
        else {
            return AnyView(List(resultLabels, id: \.id) {label in
                LabelRow(label: label)
            }.listStyle(GroupedListStyle()))
        }
       
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                Button(action: {
                    self.showingPicker.toggle()
                    
                }){
                    HStack {
                        Spacer()
                        Text("Choose pic")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .padding(.vertical, 10.0)
                .background(Color.blue)
                .padding(.horizontal, 50)
                Spacer()
                Text(verbatim: celebName!)
                Text(verbatim: unsafeContent!)
                list
                
            }
            .sheet(isPresented: $showingPicker,
                   onDismiss: {
                    // do whatever you need here
            }, content: {
                ImagePicker.shared.view
            })
            .onReceive(ImagePicker.shared.$image) { image in
                // This gets called when the image is picked.
                // sheet/onDismiss gets called when the picker completely leaves the screen
                guard let image = image else {
                    return
                }
                self.uiimage = image
                self.image = Image(uiImage: image)
            }
            .onReceive(ImagePicker.shared.$imageUrl) {imageUrl in
                guard let imageUrl = imageUrl else {
                    return
                }
                self.imageUrl = imageUrl
                self.showingActionSheet = true
                
            }
            .actionSheet(isPresented: $showingActionSheet, content: {
                self.actionSheet
            })
            .navigationBarTitle(
                Text("Identify")
            )
        }
    }
    
}

struct PredictionsIdentifyView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsIdentifyView()
            .padding()
    }
}
