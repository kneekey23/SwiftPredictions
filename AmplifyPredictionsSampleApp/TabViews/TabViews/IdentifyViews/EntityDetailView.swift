//
//  FaceDetailView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct EntityDetailView: View {
    var incomingImage: UIImage
    var entity: IdentifiedEntity
    
    var body: some View {
        ZStack {
            Image(uiImage: incomingImage)
                .resizable()
                .scaledToFit()
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .path(in: CGRect(
                                x: self.entity.boundingBox.minX * geometry.size.width,
                                y: self.entity.boundingBox.minY * geometry.size.height,
                                width: self.entity.boundingBox.width * geometry.size.width,
                                height: self.entity.boundingBox.height * geometry.size.height))
                            .stroke(Color.red, lineWidth: 2.0)
                    }
            )
        }
    }
}

