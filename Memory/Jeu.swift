//
//  Jeu.swift
//  Memory
//
//  Created by Steve VANDYCKE on 06/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Jeu{
    
    var controller : JeuController!
    var blocCartes : UIView;
    var listeCartes = [Carte]();
    var nbCartes = 28;
    var tableauImagesDisponnibles = [UIImage]();
    var carteTouchees = [Int]();
    let transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft;
    var score : Int = 0;
    var premiereCarteTapee :Bool = true;
    var nbPairesTrouvees : Int = 0;
    var tableauThemes: [String] = [String]()

    
    // Constructeur de la classe "Carte"
    init(controller : JeuController, blocCartes : UIView) {
        
        self.controller = controller;
        self.blocCartes = blocCartes;
        
        initialiserJeu();
    }
    
    func initialiserJeu(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Réinitialisation des tableaux
        self.listeCartes.removeAll();
        self.tableauImagesDisponnibles.removeAll();
        self.carteTouchees.removeAll();
        
        // Réinitialisation des variables
        controller.counterMillisecondes = 0;
        controller.counterSecondes = 0;
        controller.counterMinutes = 0;
        controller.counterGeneralMillisecondes = 0;
        self.score = 0;
        controller.ValeurScore.text = "00";
        self.premiereCarteTapee = true;
        controller.timer.invalidate();
        controller.ValeurTemps.text = String(format : "%02d:%02d", controller.counterMinutes, controller.counterSecondes);
        self.nbPairesTrouvees = 0;
        var prefixe :String = ""
        
        if(defaults.objectForKey("parametreTheme") as! String != "Aléatoire"){
            prefixe = defaults.objectForKey("parametreTheme") as! String
        }else{
            tableauThemes = defaults.objectForKey("tableauThemes") as! [String]
            tableauThemes.removeAtIndex(0)
            let themeAleatoire = Int(arc4random_uniform(UInt32(tableauThemes.count)));
            prefixe = tableauThemes[themeAleatoire]
        }
        
        controller.ValeurTheme.text = prefixe

        
        // Création du tableau d'images
        for index in 0 ..< (nbCartes/2){
            self.tableauImagesDisponnibles.append(UIImage(named : prefixe + String(index+1) + ".png")!);
            self.tableauImagesDisponnibles.append(UIImage(named : prefixe + String(index+1) + ".png")!);
        }
 
        // Création des cartes
        for vueCarte in blocCartes.subviews as [UIView] {
            
            let image = Int(arc4random_uniform(UInt32(tableauImagesDisponnibles.count)));
            // Création de la vue recto
            let imageName = "Recto_carte.png"
            let rectoCarteImage = UIImage(named: imageName);
            let rectoCarteImageView = UIImageView(image: rectoCarteImage!)
            rectoCarteImageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
            let rectoCarte = UIView();
            rectoCarte.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
            rectoCarte.addSubview(rectoCarteImageView);
            
            // Création de la vue verso
            let versoCarteImage = tableauImagesDisponnibles[image];
            let versoCarteImageView = UIImageView(image: versoCarteImage)
            versoCarteImageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
            let versoCarte = UIView();
            versoCarte.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
            versoCarte.addSubview(versoCarteImageView);
            
            let carte = Carte(vueCarte: vueCarte, rectoCarte: rectoCarte, versoCarte: versoCarte, image: versoCarteImage)
            self.listeCartes.append(carte);
            
            tableauImagesDisponnibles.removeAtIndex(image)
        }
        
        // Affichage de toutes les cartes
        for index in 0 ..< (nbCartes){
            listeCartes[index].vueCarte.addSubview(listeCartes[index].rectoCarte);
            listeCartes[index].vueCarte.hidden = false;
            listeCartes[index].vueCarte.userInteractionEnabled = true;
        }
        
        // Attribution des Gestes
        for index in 0 ..< (nbCartes){
            
            let tapRecognizer = UITapGestureRecognizer(target: controller, action: Selector("carteTouchee:"))
            listeCartes[index].vueCarte.addGestureRecognizer(tapRecognizer)
            listeCartes[index].vueCarte.tag = index
        }
    }
    
    // Fonction lorsqu'une carte est selectionnée
    func carte_selectionee(vueSelectionnee : UIView){
        
        let delay = 0.9 * Double(NSEC_PER_SEC);
        
        //Désactive l'interraction utilisateur de la carte selectionnée
        vueSelectionnee.userInteractionEnabled = false;
        
        // Teste si c'est la première carte selectionnée
        if(premiereCarteTapee == true){
            premiereCarteTapee = false;
            // Lance le chronomètre
            if(controller.timer.valid == false){
                controller.timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: controller, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            }
        }
        
        UIView.transitionFromView(self.listeCartes[vueSelectionnee.tag].rectoCarte, toView: self.listeCartes[vueSelectionnee.tag].versoCarte, duration: 0.3, options: transitionOptions, completion: nil)
        
        // Test si 2 cartes sont selectionnées
        if(self.carteTouchees.count < 2){
            self.carteTouchees.append(vueSelectionnee.tag)
            
            if(self.carteTouchees.count >= 2){
                if(tester_paire()){
                    // Paire OK
                    controller.FonctionsGeneralesObject.jouerVibration()
                    controller.FonctionsGeneralesObject.jouerSon("PaireOk")
                    active_user_interaction(false)
                    let timeOK = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(timeOK, dispatch_get_main_queue()) {
                        self.listeCartes[self.carteTouchees[0]].vueCarte.hidden = true
                        self.listeCartes[self.carteTouchees[1]].vueCarte.hidden = true
                        self.carteTouchees.removeAll()
                        self.active_user_interaction(true)
                    }
                    self.score += 10;
                    self.controller.ValeurScore.text = String(self.score)
                    self.nbPairesTrouvees += 1;
                    
                }else{
                    // Paire NOK
                    if((self.listeCartes[carteTouchees[0]].dejaretourne == true) || (self.listeCartes[carteTouchees[1]].dejaretourne == true)){
                        self.score -= 2;
                        self.controller.ValeurScore.text = String(self.score)
                    }
                    
                    // Indique les cartes déjà tournées une fois
                    self.listeCartes[carteTouchees[0]].dejaretourne = true;
                    self.listeCartes[carteTouchees[1]].dejaretourne = true;
                    
                    active_user_interaction(false)
                    let timeNOK = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(timeNOK, dispatch_get_main_queue()) {
                        for index in 0 ..< (self.carteTouchees.count){
                            UIView.transitionFromView(self.listeCartes[self.carteTouchees[index]].versoCarte, toView: self.listeCartes[self.carteTouchees[index]].rectoCarte, duration: 0.3, options: self.transitionOptions, completion: nil)
                        }
                        self.carteTouchees.removeAll()
                        self.active_user_interaction(true)
                    }
                }
                
                // Teste si la partie est terminée
                if(self.nbPairesTrouvees == (self.nbCartes/2)){
                    
                    controller.timer.invalidate()
                    testerMeilleurScore()
                    
                }
                
            }
        }else{
            for index in 0 ..< (self.carteTouchees.count){
                UIView.transitionFromView(self.listeCartes[carteTouchees[index]].versoCarte, toView: self.listeCartes[carteTouchees[index]].rectoCarte, duration: 0.3, options: transitionOptions, completion: nil)
            }
            self.carteTouchees.removeAll()
            self.carteTouchees.append(vueSelectionnee.tag)
        }
    }
    
    // Fonction qui teste une paire
    func tester_paire() -> Bool{
        if(self.listeCartes[carteTouchees[0]].image == self.listeCartes[carteTouchees[1]].image){
            return true
        }else{
            return false
        }
    }
    
    // Fonction qui active ou désactive l'interaction utilisateur
    func active_user_interaction(valeur:Bool){
        for index in 0 ..< (nbCartes){
            listeCartes[index].vueCarte.userInteractionEnabled = valeur;
        }
    }
    
    // Fonction qui teste si le score est le meilleur et enregistre si oui
    func testerMeilleurScore(){
      
        let tempsMillisecondes = controller.counterMillisecondes
        let tempsMinutes = controller.counterMinutes
        let tempsSeconde = controller.counterSecondes
        let tempsString = String(format : "%02d:%02d", tempsMinutes, tempsSeconde);
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var tableauMeilleursScores: [[String: AnyObject]] = [[String: AnyObject]]()
        
        if((defaults.objectForKey("listeMeilleursScores")) != nil){
            tableauMeilleursScores = defaults.objectForKey("listeMeilleursScores")! as! [[String : AnyObject]]
        }
        
        if(tableauMeilleursScores.count != 0){
            let meilleurScorePoints = tableauMeilleursScores[tableauMeilleursScores.count-1]["meilleurScorePoints"] as? Int
            let meilleurScoreTempsMillisecondes = tableauMeilleursScores[tableauMeilleursScores.count-1]["meilleurScoreTempsMillisecondes"] as? Int
            
            if(self.score == meilleurScorePoints){
                if(controller.counterGeneralMillisecondes <= meilleurScoreTempsMillisecondes){
                    
                    let actionSheetController: UIAlertController
                    actionSheetController = UIAlertController(title: "Nouveau meilleur score !", message: String(self.score) + " points - " + controller.ValeurTemps.text!, preferredStyle: .Alert)
                    
                    actionSheetController.addTextFieldWithConfigurationHandler { (prenomTextField) in
                        prenomTextField.placeholder = "Votre prénom"
                    }
                    
                    // Ajout de l'action "valider" à l'alerte
                    let validerAction: UIAlertAction = UIAlertAction(title: "Valider", style: .Default) { action -> Void in
                        
                        var nouveauMeilleurScore : [String: AnyObject] = [String: AnyObject]();
                        nouveauMeilleurScore["meilleurScorePoints"] = self.score as Int
                        nouveauMeilleurScore["meilleurScoreTempsString"] = tempsString as String
                        nouveauMeilleurScore["meilleurScoreTempsMillisecondes"] = self.controller.counterGeneralMillisecondes as Int
                        
                        
                        var prenom = actionSheetController.textFields![0].text! as String
                        
                        if(prenom == ""){
                            prenom = "Anonyme"
                        }
                        
                        nouveauMeilleurScore["meilleurScorePrenom"] = prenom as String
                        
                        tableauMeilleursScores.append(nouveauMeilleurScore)
                        defaults.setObject(tableauMeilleursScores, forKey: "listeMeilleursScores")
                        
                        self.alerteFinDePartie()
                    }
                    actionSheetController.addAction(validerAction)
                    
                    
                    // Afficher l'alerte
                    controller.presentViewController(actionSheetController, animated: true, completion: nil)

                }else{
                    alerteFinDePartie()
                }
            }else if(self.score > meilleurScorePoints){
               
                let actionSheetController: UIAlertController
                actionSheetController = UIAlertController(title: "Nouveau meilleur score !", message: String(self.score) + " points - " + controller.ValeurTemps.text!, preferredStyle: .Alert)
                
                actionSheetController.addTextFieldWithConfigurationHandler { (prenomTextField) in
                    prenomTextField.placeholder = "Votre prénom"
                }
                
                // Ajout de l'action "valider" à l'alerte
                let validerAction: UIAlertAction = UIAlertAction(title: "Valider", style: .Default) { action -> Void in
                    
                    var nouveauMeilleurScore : [String: AnyObject] = [String: AnyObject]();
                    nouveauMeilleurScore["meilleurScorePoints"] = self.score as Int
                    nouveauMeilleurScore["meilleurScoreTempsString"] = tempsString as String
                    nouveauMeilleurScore["meilleurScoreTempsMillisecondes"] = self.controller.counterGeneralMillisecondes as Int
                    
                    
                    var prenom = actionSheetController.textFields![0].text! as String
                    
                    if(prenom == ""){
                        prenom = "Anonyme"
                    }
                    
                    nouveauMeilleurScore["meilleurScorePrenom"] = prenom as String
                    tableauMeilleursScores.append(nouveauMeilleurScore)
                    defaults.setObject(tableauMeilleursScores, forKey: "listeMeilleursScores")
                    
                    self.alerteFinDePartie()
                }
                actionSheetController.addAction(validerAction)
                
                
                // Afficher l'alerte
                controller.presentViewController(actionSheetController, animated: true, completion: nil)
                
            }else{
                alerteFinDePartie()
            }
        }else{
            
            let actionSheetController: UIAlertController
            actionSheetController = UIAlertController(title: "Nouveau meilleur score !", message: String(self.score) + " points - " + controller.ValeurTemps.text!, preferredStyle: .Alert)
            
            actionSheetController.addTextFieldWithConfigurationHandler { (prenomTextField) in
                prenomTextField.placeholder = "Votre prénom"
            }
            
            // Ajout de l'action "valider" à l'alerte
            let validerAction: UIAlertAction = UIAlertAction(title: "Valider", style: .Default) { action -> Void in
                
                var listeMeilleursScores: [[String: AnyObject]] = [[String: AnyObject]]()
                var nouveauMeilleurScore : [String: AnyObject] = [String: AnyObject]();
                nouveauMeilleurScore["meilleurScorePoints"] = self.score as Int
                nouveauMeilleurScore["meilleurScoreTempsString"] = tempsString as String
                nouveauMeilleurScore["meilleurScoreTempsMillisecondes"] = self.controller.counterGeneralMillisecondes as Int
                
                var prenom = actionSheetController.textFields![0].text! as String
                
                if(prenom == ""){
                    prenom = "Anonyme"
                }
                
                nouveauMeilleurScore["meilleurScorePrenom"] = prenom as String
                
                tableauMeilleursScores.append(nouveauMeilleurScore)
                defaults.setObject(tableauMeilleursScores, forKey: "listeMeilleursScores")
                
                self.alerteFinDePartie()
            }
            actionSheetController.addAction(validerAction)
            
            
            // Afficher l'alerte
            controller.presentViewController(actionSheetController, animated: true, completion: nil)
        
        }
    }
    
    // Alert fin de partie
    func alerteFinDePartie(){
        let actionSheetController: UIAlertController
        
        actionSheetController = UIAlertController(title: "Partie terminée !", message: String(self.score) + " points - " + controller.ValeurTemps.text!, preferredStyle: .Alert)
        
        // Ajout de l'action "nouvelle partie" à l'alerte
        let nouvellePartie: UIAlertAction = UIAlertAction(title: "Nouvelle partie", style: .Default) { action -> Void in
            self.controller.jeu = Jeu(controller: self.controller, blocCartes: self.blocCartes)
        }
        actionSheetController.addAction(nouvellePartie)
        
        // Ajout de l'action "quitter" à l'alerte
        let quitterAction: UIAlertAction = UIAlertAction(title: "Retourner à l'accueil", style: .Default) { action -> Void in
            let vc : AnyObject! = self.controller.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
            self.controller.showViewController(vc as! UIViewController, sender: vc)
        }
        actionSheetController.addAction(quitterAction)
        
        // Afficher l'alerte
        controller.presentViewController(actionSheetController, animated: true, completion: nil)
    }

}