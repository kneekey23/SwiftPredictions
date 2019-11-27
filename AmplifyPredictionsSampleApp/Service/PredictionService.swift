//
//  PredictionService.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Roy, Jithin on 10/29/19.
//  Copyright © 2019 AWS. All rights reserved.
//

import Foundation
import Amplify

struct PredictionService {

    func predictionFunc(_ text: String) {
        let convert = ConvertRequest(text: "")
    }
    
}

struct ConvertRequest {
    var internalRequest: InternalRequest?

}


extension ConvertRequest {

    init(text: String) {
        self.internalRequest = TextToSpeechRequest()
    }
}



protocol InternalRequest {

}

struct TextToSpeechRequest: InternalRequest {

}

