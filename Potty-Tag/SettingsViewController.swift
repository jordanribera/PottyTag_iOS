//
//  SettingsViewController.swift
//  Potty-Tag
//
//  Created by Admin on 6/18/15.
//  Copyright (c) 2015 Tag Creative Studio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var defaults : NSUserDefaults!
    
    var isMale : Bool = true

    @IBOutlet weak var RadioButtonFemale: DownStateButton!
    
    @IBOutlet weak var RadioButtonMale: DownStateButton!
    
    @IBAction func OnFemaleSelected(sender: AnyObject) {
        defaults.setBool(false, forKey: "isMale")
    }

    @IBAction func OnMaleSelected(sender: AnyObject) {
        defaults.setBool(true, forKey: "isMale")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        defaults = NSUserDefaults.standardUserDefaults()
        
        
        RadioButtonMale.downStateImage = "m_cutiepoo_selected.png"
        RadioButtonFemale.downStateImage = "f_cutiepoo_selected"
        
        RadioButtonMale.myAlternateButton = [RadioButtonFemale]
        RadioButtonFemale.myAlternateButton = [RadioButtonMale]
    
        if (defaults.objectForKey("isMale") != nil) {
            isMale = defaults.boolForKey("isMale")
            
            if(isMale){
                RadioButtonMale.unselectAlternateButtons()
                RadioButtonMale.selected = true
            }else{
                RadioButtonFemale.unselectAlternateButtons()
                RadioButtonFemale.selected = true
            }
        }
        
        
        
    
    }
    
}
