//
//  FaceRow.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI
import Amplify

struct EntityRow: View {
    var image: UIImage
    var entity: IdentifiedEntity
    
    var body: some View {
        NavigationLink(destination: EntityDetailView(incomingImage: image, entity: entity)) {
            HStack {
                Text("Gender: " + entity.gender.gender.rawValue)
                Spacer()
                Text("Age: " + String(entity.ageRange.low) + " - " + String(entity.ageRange.high))
            }
        }
    }
}

