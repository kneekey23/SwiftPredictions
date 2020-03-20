//
//  TextRow.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/22/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct TextRow: View {
    var line: Line
    var image: UIImage
    
    var body: some View {
        NavigationLink (destination: TextDetailView(line: line, incomingImage: image)) {
            HStack {
                Text(line.text)
            }
        }
    }
}

