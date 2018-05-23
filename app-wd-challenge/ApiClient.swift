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
    
    var imagePath: String?
    var looking_for: String?
    var avatarPath: String?
}

public extension Notification.Name {
    public static let apiLoadStart = Notification.Name("ApiLoadStart")
    public static let apiLoadComplete = Notification.Name("ApiLoadComplete")
}

class ApiClient {
    
    static let instanc = ApiClient()
    
    var isLoading = false
    var offers = [Offer]()
    
    var url = "https://www.wantedly.com/api/v1/projects?"
    private init(){}
    
    func getOffers(q: String, page: Int){
        
        url += "q=" + q + "&page=" + String(page)
        
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
                
                offer.imagePath = company.1["image"]["i_50_50_x2"].string
                offer.looking_for = company.1["looking_for"].string
                offer.avatarPath = company.1["company"]["avatar"]["s_100"].string
                
                additionalOffers.append(offer)
                
//                print(company)
            }
            
            self.offers += additionalOffers
            self.isLoading = false
            
            NotificationCenter.default.post(name: .apiLoadComplete, object: nil)
        })
        
    }
}
