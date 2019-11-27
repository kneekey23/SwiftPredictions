//
//  SyntaxToken.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct SyntaxToken: Identifiable {
    var id: UUID
    var text: String
    var partofSpeech: String
    var score: Double
}
