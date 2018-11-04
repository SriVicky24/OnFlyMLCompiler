//
//  ViewController.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 20/7/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
//    IBOutlets
    
    @IBOutlet weak var txtEggField: UITextField!
    @IBOutlet weak var txtMilkField: UITextField!
    @IBOutlet weak var txtGlutenField: UITextField!
    @IBOutlet weak var txtGrainField: UITextField!
    @IBOutlet weak var txtNutsField: UITextField!
    @IBOutlet weak var txtProteinField: UITextField!
    @IBOutlet weak var txtTomatoField: UITextField!
    @IBOutlet weak var txtPollenField: UITextField!
    @IBOutlet weak var txtHumidityField: UITextField!
    
    @IBOutlet weak var btnPredictReaction: UIButton!
    
//    Vars
    
    var activeTextField : UITextField!
    var generator : Generator!
    
    private var modelController : ModelController!
    private var allergies : [FoodAllergy]?

    required init?(coder aDecoder: NSCoder) {
        
        modelController = ModelController.init()
        generator = modelController.generator
        
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let actionToolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        actionToolBar.barStyle = .default
        actionToolBar.items = [
            UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextWithNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        actionToolBar.sizeToFit()
        
        UITextField.appearance().inputAccessoryView = actionToolBar
        
        modelController.downloadModel()
        allergies = Helper().unarchiveFoodAllergy()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtEggField.becomeFirstResponder()
    }
    
    //    MARK: - User Defined Methods
    
    //    Method : PredictReaction
    //    Args : Nut, Tomato in Double
    //    Description: Predicts the reaction based on data passed in using FoodReactionPredictor Model.
    
    func predictReaction(forEgg egg : Double,
                         forMilk milk : Double,
                         forGluten gluten : Double,
                         forNuts nut : Double ,
                         forGrain grain : Double,
                         forProtein protein : Double,
                         forPollen pollen : Double,
                         forHumidity humidity : Double,
                         andTomato tomato : Double) {
        
        guard let foodModel = generator.model else {
            return
        }
        
    
        let reaction = try! foodModel.prediction(egg: egg,
                                             milk: milk,
                                         gluten: gluten,
                                         grain:grain ,
                                         nut: nut,
                                         protein: protein,
                                         tomato: tomato,
                                         pollen: pollen,
                                         humidity: humidity)
        
        let reactionAlertController = UIAlertController.init(title: "Information",
                                                             message: "Reaction : \(reaction.reaction)"
                                            , preferredStyle: .alert)
        
        reactionAlertController.addAction(UIAlertAction.init(title: "OK", style: .default,
                                                             handler: { action in
        
                                                                let allergy = FoodAllergy.init()
                                                                allergy.egg = egg
                                                                allergy.milk = milk
                                                                allergy.nut = nut
                                                                allergy.gluten = gluten
                                                                allergy.grain = grain
                                                                allergy.tomato = tomato
                                                                allergy.protein = protein
                                                                allergy.pollen = pollen
                                                                allergy.humidity = humidity
                                                                allergy.reaction = reaction.reaction
                                                                
                                                               self.storeAndArchiveData(with: allergy)
                                                                
                                                                
                                                                
        }))
        
        self.present(reactionAlertController,
                     animated: true, completion: nil)
    }
    
    func storeAndArchiveData(with content : FoodAllergy) {
        
        if allergies == nil {
            allergies = []
        }
        
        allergies!.append(content)
        
        if allergies!.count >= 2 {
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//
//                let csvFileLocationURL = Helper().buildCSVFile(with: self.allergies!)
//
//                NetworkManager.shared.uploadCSV(atURL: csvFileLocationURL)
//
//            }
            
        }
        
        Helper().archiveFoodAllergy(with: allergies!)

    }
    
    
    //    MARK: - IBACtion Methods
    
    @IBAction func didBtnPredictReactionTapped(_ sender: Any) {
        
        
        let nut = Double(txtNutsField.text!)!
        let tomato = Double(txtTomatoField.text!)!
        let egg = Double(txtEggField.text!)!
        let grain = Double(txtGrainField.text!)!
        let gluten = Double(txtGlutenField.text!)!
        let pollen = Double(txtProteinField.text!)!
        let hum = Double(txtHumidityField.text!)!
        let milk = Double(txtMilkField.text!)!
        let protein = Double(txtProteinField.text!)!
        
        predictReaction(forEgg: egg,
                        forMilk: milk, forGluten: gluten,
                        forNuts: nut,
                        forGrain: grain,
                        forProtein: protein,
                        forPollen: pollen,
                        forHumidity: hum,
                        andTomato: tomato)
        
    }
    
    @objc func nextWithNumberPad() {
        
        if activeTextField.tag == 8 {
            activeTextField.resignFirstResponder()
            return
        }
        
        self.view.viewWithTag(activeTextField.tag + 1)?.becomeFirstResponder()
    }
    
    @objc func doneWithNumberPad() {
        activeTextField.resignFirstResponder()
    }
    
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
