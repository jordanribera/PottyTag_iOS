//
//  ViewController.swift
//  Potty-Tag
//
//  Created by Admin on 6/18/15.
//  Copyright (c) 2015 Tag Creative Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let checkinTimeoutDuration = 120.0
    var defaults : NSUserDefaults!
    var checkin_id : Int?
    var is_checked_in : Bool = false
    var isMale : Bool = true
    var refreshTimer : NSTimer = NSTimer()
    var checkinTimeoutTimer : NSTimer = NSTimer()
    var dataSourceForCollection : Array<Gender> = []
    let pottyService : PottyService = PottyService()
    
    @IBOutlet weak var CheckinCheckOutButton: UIButton!
    
    
    @IBOutlet weak var LeftImage: UIImageView!
    
    
    @IBOutlet weak var RightImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        defaults = NSUserDefaults.standardUserDefaults()

        if (defaults.objectForKey("isMale") == nil) {
            isMale = defaults.boolForKey("isMale")
            
            let svc = self.storyboard!.instantiateViewControllerWithIdentifier("settings") as! SettingsViewController
            self.navigationController?.pushViewController(svc, animated: true)
        }
        
        if (defaults.objectForKey("checkin_id") != nil) {
            checkin_id = defaults.objectForKey("checkin_id") as? Int
            is_checked_in = true
        }else{
            is_checked_in = false
        }
        
        toggleButtonLabelText()
        updateStatus()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        if (defaults.objectForKey("isMale") != nil) {
            isMale = defaults.boolForKey("isMale")
        }
        updateStatus()
    }
    
    @IBAction func OnCheckinCheckoutClicked(sender: AnyObject) {
    
        if(is_checked_in && checkin_id != nil){//check out
            checkOut()
        }else{//check in
            checkIn()
        }
        

        
    
    }

    func checkIn(callback: () -> () = {}){

            pottyService.checkIn(isMale, lastCheckin: self.checkin_id){(response, error) in
                
                if(error != nil || response == nil){// has error
                    let alert = UIAlertView()
                    alert.title = "Error contacting Potty Tag service"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }else{
                    if(response != nil && (response!.success) != nil && response!.success!){
                        self.defaults.setInteger(response!.checkin_id!, forKey: "checkin_id")
                        self.checkin_id = response!.checkin_id!
                        self.is_checked_in = true
                        
                        //start checkin timeout timer!
                        self.checkinTimeoutTimer.invalidate()
                        self.checkinTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(self.checkinTimeoutDuration, target: self, selector: Selector("CheckinOverTimoutDuration"), userInfo: nil, repeats: false)
                        
                    }
                }
                self.toggleButtonLabelText()
                self.updateStatus()
                callback()
            }
            
        
    }
    
    func checkOut(callback: () -> () = {}){
        if let cid = checkin_id{
            pottyService.checkOut(isMale, checkinId: cid){(response, error) in
                if(error != nil || response == nil){// has error
                    let alert = UIAlertView()
                    alert.title = "Error contacting Potty Tag service"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }else{
                    if(response != nil && (response!.success) != nil && response!.success!){
                        self.defaults.removeObjectForKey("checkin_id")
                        self.checkin_id = nil
                        self.is_checked_in = false
                    }
                }
                self.checkinTimeoutTimer.invalidate()
                self.toggleButtonLabelText()
                self.updateStatus()
            }
            callback()
            
        }
        

    }
    
    
    func toggleButtonLabelText(){
        if (is_checked_in){
            CheckinCheckOutButton.setTitle("Check Out", forState: UIControlState.Normal)
        }else{
            CheckinCheckOutButton.setTitle("Check In", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func OnRefreshClicked(sender: AnyObject) {
        updateStatus()
    }
    
    func updateStatus(){
        pottyService.getStatus{(response, error) in
            if let resp = response{
                var male_total = resp.male_population!
                var female_total = resp.female_population!
                var all_total = female_total + male_total
                
                self.LeftImage.image = nil
                self.RightImage.image = nil
                
                println("status:")
                println(resp.female_population)
                println(resp.male_population)
                self.dataSourceForCollection = Array<Gender>()
                
                if(male_total > 0 && female_total > 0 ){
                    self.dataSourceForCollection.append(Gender.Female)
                    self.dataSourceForCollection.append(Gender.Male)
                    self.LeftImage.image = UIImage(named: "in_use_m")
                    self.RightImage.image = UIImage(named: "in_use_f")
                    
                }else{
                    
                    if(all_total >= 2){
                        
                        if(male_total > 1){
                            self.LeftImage.image = UIImage(named: "in_use_m")
                            self.RightImage.image = UIImage(named: "in_use_m")
                        }else{
                            self.LeftImage.image = UIImage(named: "in_use_f")
                            self.RightImage.image = UIImage(named: "in_use_f")
                        }

                    }else if(all_total == 1){
                        if(female_total > 0){
                            self.LeftImage.image = UIImage(named: "in_use_f")
                        }else{
                            self.LeftImage.image = UIImage(named: "in_use_m")

                        }
                    }
                
                }

            }else{
                let alert = UIAlertView()
                alert.title = "Error contacting Potty Tag service"
                alert.addButtonWithTitle("OK")
                alert.show()
            }

            
        }
    }
    
    func CheckinOverTimoutDuration(){
        var refreshAlert = UIAlertController(title: "Are you still in there?", message: "Just checkin in...", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "\"Someones in here!\"", style: .Default, handler: { (action: UIAlertAction!) in
            self.checkOut(callback: {
                self.checkIn()
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nope, Im done", style: .Default, handler: { (action: UIAlertAction!) in
            self.checkOut()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

