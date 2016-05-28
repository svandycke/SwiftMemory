//
//  FonctionsGenerales.swift
//  Memory
//
//  Created by Steve VANDYCKE on 11/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import AVFoundation
import SystemConfiguration


class FonctionsGenerales{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let soungPaireOk = NSBundle.mainBundle().pathForResource("dingSound", ofType: "caf")
    var  audioPlayerPaireOk: AVAudioPlayer!
    let url : NSURL    
    var tableauThemes: [String] = [String]()
    
    init(){
        
        
        // Implémentation son paire Ok
        url = NSURL(fileURLWithPath: soungPaireOk!)
        do{
            audioPlayerPaireOk = try AVAudioPlayer(contentsOfURL: url)
        }catch _ {
             audioPlayerPaireOk = nil
        }
    }
    
    // Fonction qui initialise les paramètres par défaut en cas de premier lancement de l'application
    func initialisationDesParametres(){
        
        // Insertion des thèmes dans le tableau en mémoire
        tableauThemes.append("Aléatoire")
        tableauThemes.append("Animaux")
        tableauThemes.append("Dessins animés")
        tableauThemes.append("Objets")
        
        // Vibrations
        if((defaults.objectForKey("parametreVibrations")) == nil){
            defaults.setObject(true, forKey: "parametreVibrations")
        }
        
        // Sons
        if((defaults.objectForKey("parametreSons")) == nil){
            defaults.setObject(true, forKey: "parametreSons")
        }
        
        // Theme
        if((defaults.objectForKey("parametreTheme")) == nil){
            defaults.setObject("Aléatoire", forKey: "parametreTheme")
        }
        
        defaults.setObject(tableauThemes, forKey: "tableauThemes")
        
    }
    
    // Fonction qui joue une vibration si l'option est activée
    func jouerVibration(){
        
        if((defaults.objectForKey("parametreVibrations") as! Bool) == true){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    
    // Fonction qui joue un son si l'option est activée
    func jouerSon(titre : String){
        if((defaults.objectForKey("parametreSons") as! Bool) == true){
            
            switch titre {
            case "PaireOk":
                audioPlayerPaireOk.numberOfLoops = 0
                audioPlayerPaireOk.prepareToPlay()
                audioPlayerPaireOk.play()
                break
            default:
                break
            }
    
        }
    }
    
    // Fonction qui teste si le reseau est disponnible
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

