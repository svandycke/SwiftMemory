//
//  MeilleursScoresController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 11/04/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class MeilleursScoresController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ImageHome: UIImageView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var tableauMeilleursScores: [[String: AnyObject]] = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ajout de la fonction retour à l'accueil à l'image Home
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MeilleursScoresController.homeTouche(_:)))
        ImageHome.addGestureRecognizer(tapRecognizer)
        
        if((defaults.objectForKey("listeMeilleursScores")) != nil){
            tableauMeilleursScores = defaults.objectForKey("listeMeilleursScores")! as! [[String : AnyObject]]
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauMeilleursScores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let row = indexPath.row
        
        let scorePoints = String(tableauMeilleursScores[row]["meilleurScorePoints"] as! Int)
        let scoreTemps = tableauMeilleursScores[row]["meilleurScoreTempsString"] as! String
        let scorePrenom = tableauMeilleursScores[row]["meilleurScorePrenom"] as! String

        
        cell.textLabel?.text = scorePoints + " Points - " + scoreTemps + " - " + scorePrenom
        
        return cell
    }
    
   // Fonction qui s'execute quand une ligne du tableau est selectionnée
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        let reinitialiserScore = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        reinitialiserScore.addAction(UIAlertAction(title: "Supprimer le score", style: .Destructive, handler: { (action: UIAlertAction!) in

            self.tableauMeilleursScores.removeAtIndex(row)
            self.defaults.setObject(self.tableauMeilleursScores, forKey: "listeMeilleursScores")
            
            self.tableView.reloadData()
            
            
        }))
        
        reinitialiserScore.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(reinitialiserScore, animated: true, completion: nil)
        
    }
    
    // Fonction executée lorsque le bouton home est touché
    func homeTouche(gestureRecognizer: UITapGestureRecognizer) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Accueil")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
    
    
    
}