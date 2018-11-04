//
//  Helper.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 3/8/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

class Helper {
    
    
    /**
     * Method name: ArchiveFoodIntake
     * Description: Archives array of Food Intake information and stores in UserDefaults.
     * Parameters: nil
     * Return: nil
     */
    
    public func archiveFoodAllergy(with allergies : [FoodAllergy]) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: allergies)
        let userDefault = UserDefaults.init(suiteName: "FoodAllergyDataSet")
        userDefault?.set(data, forKey: "FoodAllergy")
        
        userDefault?.synchronize()
        
    }
    
    
    public func unarchiveFoodAllergy() -> [FoodAllergy]? {
        
        let userDefault = UserDefaults.init(suiteName: "FoodAllergyDataSet")
        let unarchiveData = userDefault?.value(forKey: "FoodAllergy") as? Data
        
        guard let data = unarchiveData else {
            return nil
        }
        
        return (NSKeyedUnarchiver.unarchiveObject(with: data) as! [FoodAllergy])
        
        
    }

    /**
     * Method name: BuildCSVFile
     * Description: Builds a csv file with foodintake information.
     * Parameters: Array of FoodAllergy : Object
     * Return: 
     */

    
   public func buildCSVFile(with foodIntakeData : [FoodAllergy]) -> URL {
    
    
    let fileName = "FoodIntakeSample.csv"
    let documentURL = FileManager.default.urls(for: .documentDirectory,
                                        in:   .userDomainMask)[0].appendingPathComponent(fileName)


    var rows : [String] = []

    for intake in foodIntakeData {
        rows.append(intake.getCSVString())
    }
    rows.insert("egg,milk,gluten,grain,nut,protein,tomato,pollen,humidity,reaction", at: 0)
    let content  = rows.joined(separator: "\n")
    
    do {
        try! content.write(to: documentURL,
                           atomically: true,
                           encoding: .utf8)
        
        return documentURL
        
        }
    }
}

