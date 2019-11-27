//
//  TextDetailView.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI
import Amplify
import CoreGraphics
import UIKit

struct TextDetailView: View {
    var line: Line
    var incomingImage: UIImage
    
    var body: some View {
        ZStack {
            Image(uiImage: incomingImage)
                .resizable()
                .scaledToFit()
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .path(in: CGRect(
                                x: self.line.boundingBox.minX * geometry.size.width,
                                y: self.line.boundingBox.minY * geometry.size.height,
                                width: self.line.boundingBox.width * geometry.size.width,
                                height: self.line.boundingBox.height * geometry.size.height))
                            .stroke(Color.red, lineWidth: 2.0)
                    }
            )
        }
        
    }
}
