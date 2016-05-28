//
//  ParametresController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 10/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class ParamètresController: UITableViewController {
    
    
    @IBOutlet weak var ImageHome: UIImageView!
    @IBOutlet weak var switchVibrations: UISwitch!
    @IBOutlet weak var switchSons: UISwitch!
    @IBOutlet weak var labelTheme: UILabel!
    
    let FonctionsGeneralesObject = FonctionsGenerales()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ajout de la fonction retour à l'accueil à l'image Home
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(homeTouche(_:)))
        ImageHome.addGestureRecognizer(tapRecognizer)
        
        // Initialisation du switch vibration
        switchVibrations.on = defaults.objectForKey("parametreVibrations")! as! Bool
        
        // Initialisation du switch sons
        switchSons.on = defaults.objectForKey("parametreSons")! as! Bool
        
        // Initialisation du label thème
        labelTheme.text = defaults.objectForKey("parametreTheme")! as? String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fonction executée lorsque le bouton home est touché
    func homeTouche(gestureRecognizer: UITapGestureRecognizer) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
    
    // Fonction executée lorsque le switch vibrations change d'état
    @IBAction func ActionSwitchVibrations(sender: AnyObject) {
        defaults.setObject(switchVibrations.on, forKey: "parametreVibrations")
        if(switchVibrations.on == true){
            FonctionsGeneralesObject.jouerVibration()
        }
    }
    
    // Fonction executée lorsque le switch sons change d'état
    @IBAction func ActionSwitchSons(sender: AnyObject) {
        defaults.setObject(switchSons.on, forKey: "parametreSons")
    }
    
    @IBAction func reinitialiserLesScores(sender: AnyObject) {
        
        FonctionsGeneralesObject.jouerVibration()
        let reinitialiserMeilleurScoreAction = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        reinitialiserMeilleurScoreAction.addAction(UIAlertAction(title: "Réinitialiser les scores", style: .Destructive, handler: { (action: UIAlertAction!) in
            let defaults = NSUserDefaults.standardUserDefaults()
            if(defaults.objectForKey("listeMeilleursScores") != nil){
                defaults.removeObjectForKey("listeMeilleursScores")
            }
        }))
        
        reinitialiserMeilleurScoreAction.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(reinitialiserMeilleurScoreAction, animated: true, completion: nil)
        
    }
    
}