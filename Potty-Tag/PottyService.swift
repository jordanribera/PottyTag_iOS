//
//  PottyService.swift
//  Potty-Tag
//
//  Created by Admin on 6/18/15.
//  Copyright (c) 2015 Tag Creative Studio. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper


class PottyService {
    var apihost = "http://spiralpower.net/pottytag/api"
    var currentRequest : Request? = nil
    
    
    func checkIn(isMale: Bool, lastCheckin: Int? = nil, completionHandler: (response: PottyServiceResponse?, error: NSError?) -> ()){
        let gender = (isMale ? "m" : "f")
        currentRequest = Alamofire.request(.GET, "\(apihost)/?r=action&action=checkin&gender=\(gender)&last_checkin=\(lastCheckin)").responseJSON{(_,_,JSON, error) in
            var responseObj = Mapper<PottyServiceResponse>().map(NSString())
            if(JSON != nil){
                responseObj = Mapper<PottyServiceResponse>().map(JSON!)
            }
                completionHandler(response: responseObj, error: error)
            }
    }
    
    func checkOut(isMale: Bool, checkinId : Int, completionHandler: (response: PottyServiceResponse?, error: NSError?) -> ()){
        let gender = (isMale ? "m" : "f")
        currentRequest = Alamofire.request(.GET, "\(apihost)/?r=action&action=checkout&last_checkin=\(checkinId)&gender=\(gender)").responseJSON{(_,_,JSON, error) in
                var responseObj = Mapper<PottyServiceResponse>().map(NSString())
                if(JSON != nil){
                    responseObj = Mapper<PottyServiceResponse>().map(JSON!)
                }
                completionHandler(response: responseObj, error: error)
            }
    }
    
    func getStatus(completionHandler: (response: PottyServiceResponse?, error: NSError?) -> ()){
        currentRequest = Alamofire.request(.GET, "\(apihost)/?r=status").responseJSON{(_,_,JSON, error) in
            println(JSON)
            var responseObj = Mapper<PottyServiceResponse>().map(NSString())
            if(JSON != nil){
                responseObj = Mapper<PottyServiceResponse>().map(JSON!)
            }
            completionHandler(response: responseObj, error: error)
        }
    }
    
    func cancelCurrentRequest(){
        if let r = self.currentRequest{
            r.cancel()
        }
    }

}



class PottyServiceResponse : Mappable {
    var checkin_id: Int?
    var male_population : Int?
    var female_population : Int?
    var success : Bool!
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        checkin_id <- map["id"]
        female_population <- map["f_population"]
        male_population <- map["m_population"]
    }
}


