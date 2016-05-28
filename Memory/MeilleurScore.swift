//
//  MeilleurScore.swift
//  Memory
//
//  Created by Steve VANDYCKE on 11/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class MeilleurScore{
    
    // Définition des variables
    var meilleurScorePoints: Int!
    var meilleurScoreTempsString : String!
    var meilleurScoreTempsMillisecondes : Int!
    
    // Constructeur de la classe "MeilleurScore"
    init(meilleurScorePoints: Int!, meilleurScoreTempsString: String!, meilleurScoreTempsMillisecondes: Int!) {
        self.meilleurScorePoints = meilleurScorePoints;
        self.meilleurScoreTempsString = meilleurScoreTempsString;
        self.meilleurScoreTempsMillisecondes = meilleurScoreTempsMillisecondes;
    }
}