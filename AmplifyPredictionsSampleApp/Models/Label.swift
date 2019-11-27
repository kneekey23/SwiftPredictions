//
//  Label.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/11/19.
//  Copyright © 2019 AWS. All rights reserved.
//
import SwiftUI

struct IdentifyLabel: Identifiable {
    var id: UUID
    var name: String
    var confidence: Double
}
