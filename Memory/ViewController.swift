//
//  ViewController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 16/03/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ViewReset: UIView!
    @IBOutlet weak var meilleurScorePoints: UILabel!
    @IBOutlet weak var meilleurScoreTempsString: UILabel!
    var niveau: Int = 0;
    let FonctionsGeneralesObject = FonctionsGenerales()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FonctionsGeneralesObject.isConnectedToNetwork()){
            print("OK")
        }else{
            print("NOK")
        }
        
        // Initialisation des paramètres
        FonctionsGeneralesObject.initialisationDesParametres()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.reinitialiserMeileurScore(_:)))
        self.ViewReset.addGestureRecognizer(longPressRecognizer)
        
        // Récupère le meilleur score enregistré
        chargerMeilleurScore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fonction qui charge le meilleur score
    func chargerMeilleurScore(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var tableauMeilleursScores: [[String: AnyObject]] = [[String: AnyObject]]()
        
        if((defaults.objectForKey("listeMeilleursScores")) != nil){
            tableauMeilleursScores = defaults.objectForKey("listeMeilleursScores")! as! [[String : AnyObject]]
        }
        
        if(tableauMeilleursScores.count == 0){
            meilleurScorePoints.text = "0"
            meilleurScoreTempsString.text = "Aucun score enregistré"
        }else{
            
            let meilleurScorePointsInt = tableauMeilleursScores[tableauMeilleursScores.count-1]["meilleurScorePoints"] as! Int
            
            meilleurScorePoints.text = String(meilleurScorePointsInt)
            meilleurScoreTempsString.text = tableauMeilleursScores[tableauMeilleursScores.count-1]["meilleurScoreTempsString"] as? String
        }

    }
    
    // Fonction réinitialiser meilleur score
    func reinitialiserMeileurScore(sender: UILongPressGestureRecognizer)
    {
        
        if sender.state == UIGestureRecognizerState.Began{
            
            FonctionsGeneralesObject.jouerVibration()
            let reinitialiserMeilleurScoreAction = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            reinitialiserMeilleurScoreAction.addAction(UIAlertAction(title: "Réinitialiser les scores", style: .Destructive, handler: { (action: UIAlertAction!) in
                let defaults = NSUserDefaults.standardUserDefaults()
                if(defaults.objectForKey("listeMeilleursScores") != nil){
                    defaults.removeObjectForKey("listeMeilleursScores")
                }
                self.chargerMeilleurScore()
            }))
            
            reinitialiserMeilleurScoreAction.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(reinitialiserMeilleurScoreAction, animated: true, completion: nil)
            
        }
    }
    
}

