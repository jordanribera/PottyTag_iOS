//
//  RadioButton.swift
//  Potty-Tag
//
//  Created by Admin on 6/18/15.
//  Copyright (c) 2015 Tag Creative Studio. All rights reserved.
//

import UIKit

class DownStateButton : UIButton {
    
    var myAlternateButton:Array<DownStateButton>?
    
    var downStateImage:String? = "radiobutton_down.png"{
        
        didSet{
            
            if downStateImage != nil {
                
                self.setImage(UIImage(named: downStateImage!), forState: UIControlState.Selected)
            }
        }
    }
    
    func unselectAlternateButtons(){
        
        if myAlternateButton != nil {
            
            self.selected = true
            
            for aButton:DownStateButton in myAlternateButton! {
                
                aButton.selected = false
            }
            
        }else{
            
            toggleButton()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        unselectAlternateButtons()
        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
    }
    
    func toggleButton(){
        
        if self.selected==false{
            
            self.selected = true
        }else {
            
            self.selected = false
        }
    }
}