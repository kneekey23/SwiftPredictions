//
//  Entity.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//
import CoreGraphics
import SwiftUI
import Amplify

struct IdentifiedEntity: Identifiable {
    var id: UUID
    var boundingBox: CGRect
    var ageRange: AgeRange
    var gender: GenderAttribute
}
