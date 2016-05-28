//
//  ViewController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 16/03/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import UIKit

class JeuController: UIViewController {
    
    
    @IBOutlet weak var ValeurScore: UILabel!
    @IBOutlet weak var ValeurTemps: UILabel!
    @IBOutlet weak var BlocCartes: UIView!
    @IBOutlet weak var ImageHome: UIImageView!
    @IBOutlet weak var ValeurTheme: UILabel!
    
    var jeu : Jeu!;
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var counterMillisecondes = 0;
    var counterSecondes = 0;
    var counterMinutes = 0;
    var counterGeneralMillisecondes = 0;
    let FonctionsGeneralesObject = FonctionsGenerales()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attribution de la fonction qui se déclanchera quand l'application est mise en arrière plan
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "appMiseArrierePlan", name: UIApplicationWillResignActiveNotification, object: nil)
        
        // Ajout de la fonction retour à l'accueil à l'image Home
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(JeuController.homeTouche(_:)))
        ImageHome.addGestureRecognizer(tapRecognizer)     
        
        // Nouveau jeu
        jeu = Jeu(controller: self, blocCartes: BlocCartes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fonction executée lorsqu'une carte est touchée
    func carteTouchee(gestureRecognizer: UITapGestureRecognizer) {
        
        // Maximum 2 cartes à la fois
        if(jeu.carteTouchees.count < 2){
            jeu.carte_selectionee(gestureRecognizer.view! as UIView)
        }
    }
    
    // Fonction executée lorsque le bouton home est touché
    func homeTouche(gestureRecognizer: UITapGestureRecognizer) {
        if(jeu.premiereCarteTapee != true){
            
            // Arrêt du chronomètre
            self.timer.invalidate()
            
            // Crétation de l'alerlte
            let actionSheetController: UIAlertController = UIAlertController(title: "Partie en pause !", message: nil, preferredStyle: .Alert)
            
            // Ajout de l'action "Reprendre" à l'alerte
            let repprendreAction: UIAlertAction = UIAlertAction(title: "Reprendre", style: .Default) { action -> Void in
                if(self.timer.valid == false){
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(JeuController.updateTime), userInfo: nil, repeats: true)
                }
            }
            actionSheetController.addAction(repprendreAction)
            
            // Ajout de l'action "Quitter la partie" à l'alerte
            let recommencerAction: UIAlertAction = UIAlertAction(title: "Recommencer", style: .Default) { action -> Void in
                    self.jeu.initialiserJeu()
            }
            actionSheetController.addAction(recommencerAction)
            
            // Ajout de l'action "Quitter la partie" à l'alerte
            let quitterAction: UIAlertAction = UIAlertAction(title: "Retourner à l'accueil", style: .Default) { action -> Void in
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            actionSheetController.addAction(quitterAction)
            
            // Afficher l'alerte
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }else{
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
            self.showViewController(vc as! UIViewController, sender: vc)
        }
        
    }
    
    // Fonction qui met à jour le chronomètre
    func updateTime() {
        counterGeneralMillisecondes += 1;
        
        if(counterMillisecondes == 999){
            counterMillisecondes = 0;
            if(counterSecondes == 59){
                counterSecondes = 0
                counterMinutes += 1
                
            }else{
                counterSecondes += 1
            }
        }else{
            counterMillisecondes += 1
        }
        
        self.ValeurTemps.text = String(format : "%02d:%02d", self.counterMinutes, self.counterSecondes);
    }
    
    // Fonction qui met en pause la partie lorsque l'application passe en arrière plan
    func appMiseArrierePlan() {
        if(jeu.premiereCarteTapee != true){
            
            // Arrêt du chronomètre
            self.timer.invalidate()
            
            // Crétation de l'alerlte
            let actionSheetController: UIAlertController = UIAlertController(title: "Partie en pause !", message: nil, preferredStyle: .Alert)
            
            // Ajout de l'action "Reprendre" à l'alerte
            let repprendreAction: UIAlertAction = UIAlertAction(title: "Reprendre", style: .Default) { action -> Void in
                if(self.timer.valid == false){
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(JeuController.updateTime), userInfo: nil, repeats: true)
                }
            }
            actionSheetController.addAction(repprendreAction)
            
            // Ajout de l'action "Quitter la partie" à l'alerte
            let recommencerAction: UIAlertAction = UIAlertAction(title: "Recommencer", style: .Default) { action -> Void in
                self.jeu.initialiserJeu()
            }
            actionSheetController.addAction(recommencerAction)
            
            // Ajout de l'action "Quitter la partie" à l'alerte
            let quitterAction: UIAlertAction = UIAlertAction(title: "Retourner à l'accueil", style: .Default) { action -> Void in
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            actionSheetController.addAction(quitterAction)
            
            // Afficher l'alerte
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }else{
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
            self.showViewController(vc as! UIViewController, sender: vc)
        }
    }
}

