//
//  CreditsController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 08/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class CreditsController: UIViewController {
    
    @IBOutlet weak var ImageHome: UIImageView!
    @IBOutlet weak var PhotoSteveVandycke: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoSteveVandycke.layer.shadowOpacity = 0.5
        PhotoSteveVandycke.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        // Ajout de la fonction retour à l'accueil à l'image Home
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreditsController.parametresTouche(_:)))
        ImageHome.addGestureRecognizer(tapRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fonction executée lorsque le bouton home est touché
    func parametresTouche(gestureRecognizer: UITapGestureRecognizer) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Parametres")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
}