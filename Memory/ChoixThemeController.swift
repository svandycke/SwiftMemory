//
//  ChoixThemeController.swift
//  Memory
//
//  Created by Steve VANDYCKE on 02/05/2016.
//  Copyright © 2016 IUT d'Orsay. All rights reserved.
//

import Foundation
import UIKit

class ChoixThemeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ImageHome: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var tableauThemes: [String] = [String]()
    var lastSelectedIndexPath: NSIndexPath?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableauThemes = defaults.objectForKey("tableauThemes") as! [String]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Ajout de la fonction retour à l'accueil à l'image Home
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreditsController.parametresTouche(_:)))
        ImageHome.addGestureRecognizer(tapRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauThemes.count
    }
    
    // Fonction qui initialiser les cellules
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let row = indexPath.row
        
        var parametreTheme = ""
        
        if((defaults.objectForKey("parametreTheme")) != nil){
           parametreTheme = defaults.objectForKey("parametreTheme") as! String
        }
        
        if( parametreTheme == tableauThemes[row]){
            cell.accessoryType = .Checkmark
            cell.textLabel?.text = tableauThemes[row]
        }else{
            cell.accessoryType = .None
            cell.textLabel?.text = tableauThemes[row]
        }
        
        return cell
    }
    
    // Fonction qui s'execute quand une ligne du tableau est selectionnée
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let row = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        defaults.setObject(tableauThemes[row], forKey: "parametreTheme")
        
        tableView.reloadData()
        

    }
    
    // Fonction executée lorsque le bouton home est touché
    func parametresTouche(gestureRecognizer: UITapGestureRecognizer) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Parametres")
        self.showViewController(vc as! UIViewController, sender: vc)
    }
}