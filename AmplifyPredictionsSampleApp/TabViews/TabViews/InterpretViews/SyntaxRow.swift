//
//  SyntaxRow.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct SyntaxRow: View {
    var token: SyntaxToken
    
    var body: some View {
        HStack {
            Text(token.text)
            Spacer()
            VStack {
            Text(token.partofSpeech)
            Text(String(format: "%.2f", token.score))
            }
        }
    }
}
