//
//  LabelRow.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/11/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import SwiftUI

struct LabelRow: View {
    var label: IdentifyLabel

    var body: some View {
        HStack {
            Text(label.name)
            Spacer()
            Text(String(format: "%.2f", label.confidence))
        }
    }
}


