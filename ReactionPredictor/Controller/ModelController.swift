//
//  ModelController.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 1/8/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreML

class ModelController {
    
    var fileManager : FileManager = FileManager.default
    
    // Document Directory URL
    var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // MLModelURL
    var downloadedModelURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("FoodReactionPredictor.mlmodel")
    
    // URL to Model Compiled Path.
    var compiledModelURL : URL!
    
    var generator : Generator!
    
    var manager : NetworkManager!
    
 
    init() {
        
        guard let originalPath = Bundle.main.url(forResource: "FoodReactionPredictor", withExtension: ".mlmodelc") else {
            return
        }
        
        self.compiledModelURL = documentURL.appendingPathComponent("FoodReactionPredictor.mlmodelc")
        
        
        do {
            
            var isDirectory : ObjCBool = true
            if fileManager.fileExists(atPath: compiledModelURL.path, isDirectory: &isDirectory) {
                try fileManager.removeItem(at: compiledModelURL)
            }
            try fileManager.copyItem(at: originalPath, to: compiledModelURL)
            
            self.generator = Generator(compiledModelURL)
            self.manager = NetworkManager.shared
            
        }
        
        catch let error {
            print(error)
        }
        
    }
    
    
    //MARK: - User Defined Methods
    
    func downloadModel() {
        
        // Specify AWS Model URL here.
        let modelUrl = URL.init(string: "")!
        
       manager.downloadModelAndMove(atURL: modelUrl,
                                           to: downloadedModelURL) { (hasFinished) in
                                            
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                
                                                self.compileDownloadedModel()
                                                
                                                DispatchQueue.main.async {
                                                    print("New Model has compiled")
                                                }
                                            }
                                            
        }
        
    }
    
    private func compileDownloadedModel() {
        
        let compiledModelURL = try? MLModel.compileModel(at: downloadedModelURL)
        generator.setModel(with: compiledModelURL!)
        
        var isDirectory : ObjCBool = true
       
        do {
        
            if fileManager.fileExists(atPath: self.compiledModelURL.path, isDirectory: &isDirectory) {
                try fileManager.removeItem(at: self.compiledModelURL)
            }
            
            try fileManager.moveItem(at: compiledModelURL!,
                                         to:   self.compiledModelURL)
            
            try fileManager.removeItem(at: compiledModelURL!.deletingLastPathComponent())
        }
        catch let error {
            print(error)
        }
    }
}
