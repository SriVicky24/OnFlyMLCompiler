//
//  Generator.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 1/8/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreML

class Generator {
    
    var model : FoodReactionPredictor?
    
    init(_ modelUrl : URL) {
        self.model = try? FoodReactionPredictor.init(contentsOf: modelUrl)
    }
    
    func setModel(with newModelURL : URL) {
        self.model = try? FoodReactionPredictor.init(contentsOf: newModelURL)
    }
}
