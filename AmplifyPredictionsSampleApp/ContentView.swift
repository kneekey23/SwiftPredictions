//
//  ContentView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 10/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
 
    var body: some View {
        TabView(selection: $selection){
            PredictionsInterpretView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Interpret")
                    }
                }
                .tag(0)
            PredictionsIdentifyView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Identify")
                    }
                }
                .tag(1)
            PredictionsConvertView()
            .font(.title)
            .tabItem {
                VStack {
                    Image("second")
                    Text("Convert")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
