//
//  Carte.swift
//  Memory
//
//  Created by Steve VANDYCKE on 06/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class Carte{
    
    // Définition des variables
    var vueCarte:UIView!
    var rectoCarte:UIView!
    var versoCarte:UIView!
    var image:UIImage!
    var dejaretourne:Bool!
    
    // Constructeur de la classe "Carte"
    init(vueCarte: UIView! ,rectoCarte : UIView!, versoCarte : UIView, image : UIImage) {
        self.vueCarte = vueCarte;
        self.rectoCarte = rectoCarte;
        self.versoCarte = versoCarte;
        self.image = image;
        self.dejaretourne = false;
    }
}