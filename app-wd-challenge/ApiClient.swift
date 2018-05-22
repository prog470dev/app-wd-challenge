//
//  ApiClient.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/21.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import Alamofire
import SwiftyJSON

public struct Offer{
    var title: String?
    var name: String?
    var description: String?
}

public extension Notification.Name {
    public static let apiLoadStart = Notification.Name("ApiLoadStart")
    public static let apiLoadComplete = Notification.Name("ApiLoadComplete")
}

class ApiClient {
    
    static let instanc = ApiClient()
    
    var isLoading = false
    var offers = [Offer]()
    
    private init(){}
    
    func getOffers(url: String){
        
        var additionalOffers = [Offer]()
        
        guard !isLoading else { return }
        
        NotificationCenter.default.post(name: .apiLoadStart, object: nil)
        
        isLoading = true

        Alamofire.request(url, method: .get).responseJSON(completionHandler: {response in
            
            guard let object = response.result.value else {
                return
            }
            
            let json = JSON(object)
            
            for company in json["data"] {
                var offer = Offer()
                offer.title = company.1["title"].string
                offer.name = company.1["company"]["name"].string
                offer.description = company.1["description"].string
                
                additionalOffers.append(offer)
            }
            
            self.offers += additionalOffers
            self.isLoading = false
            
            NotificationCenter.default.post(name: .apiLoadComplete, object: nil)
        })
        
    }
}
