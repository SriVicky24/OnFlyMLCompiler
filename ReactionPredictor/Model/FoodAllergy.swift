//
//  FoodIntake.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 3/8/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

class FoodAllergy : NSObject, NSCoding {
    
    var egg : Double!
    var milk : Double!
    var gluten : Double!
    var grain : Double!
    var nut : Double!
    var tomato : Double!
    var pollen : Double!
    var humidity : Double!
    var protein : Double!
    var reaction : Int64!
//    var timeStamp : TimeInterval!
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.egg, forKey: "Egg")
        aCoder.encode(self.milk, forKey: "Milk")
        aCoder.encode(self.gluten, forKey: "Gluten")
        aCoder.encode(self.grain, forKey: "Grain")
        aCoder.encode(self.nut, forKey: "Nut")
        aCoder.encode(self.tomato, forKey: "Tomato")
        aCoder.encode(self.pollen, forKey: "Pollen")
        aCoder.encode(self.humidity, forKey: "Humidity")
        aCoder.encode(self.protein, forKey: "Protein")
        aCoder.encode(self.reaction, forKey: "Reaction")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.egg = aDecoder.decodeObject(forKey: "Egg") as? Double
        self.milk = aDecoder.decodeObject(forKey: "Milk") as? Double
        self.gluten = aDecoder.decodeObject(forKey: "Gluten") as? Double
        self.grain = aDecoder.decodeObject(forKey: "Grain") as? Double
        self.tomato = aDecoder.decodeObject(forKey: "Tomato") as? Double
        self.pollen = aDecoder.decodeObject(forKey: "Pollen") as? Double
        self.protein = aDecoder.decodeObject(forKey: "Protein") as? Double
        self.nut = aDecoder.decodeObject(forKey: "Nut") as? Double
        self.humidity = aDecoder.decodeObject(forKey: "Humidity") as? Double
        self.reaction = aDecoder.decodeObject(forKey: "Reaction") as? Int64
        
    }
    
    
    func getCSVString() -> String {
        return "\(egg!),\(milk!),\(gluten!),\(grain!),\(nut!),\(protein!),\(tomato!),\(pollen!),\(humidity!),\(reaction!)"
    }
    
    func getCSVColumn() -> String {
        return "egg,milk,gluten,grain,nut,protein,tomato,pollen,humidity,reaction"
    }
    
}
