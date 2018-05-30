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
    var headerImagePath: String?
    var looking_for: String?
    var avatarPath: String?
}

public extension Notification.Name {
    public static let apiLoadStart = Notification.Name("ApiLoadStart")
    public static let apiLoadComplete = Notification.Name("ApiLoadComplete")
}

class ApiClient {
    
    static let Instance = ApiClient()
    
    var isLoading = false
    var offers = [Offer]()
    
    var baseUrl = "https://www.wantedly.com/api/v1/projects?"
    private init(){}
    
    /////
    func getOffers(q: String, page: Int, waiting: (() -> ())?, completion: (() -> ())?){
        
        let url = baseUrl + "q=" + q + "&page=" + String(page)
        let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        var additionalOffers = [Offer]()
        
        guard !isLoading else { return }
        
        waiting?()
        
        isLoading = true
        
        Alamofire.request(encodeUrl!, method: .get).responseJSON(completionHandler: {response in
            
            guard let object = response.result.value else {
                return
            }
            
            let json = JSON(object)
            
            for company in json["data"] {
                var offer = Offer()
                offer.title = company.1["title"].string
                offer.name = company.1["company"]["name"].string
                offer.description = company.1["description"].string
                
                offer.headerImagePath = company.1["image"]["i_320_131"].string
                offer.imagePath = company.1["image"]["i_50_50_x2"].string
                offer.looking_for = company.1["looking_for"].string
                offer.avatarPath = company.1["company"]["avatar"]["s_100"].string
                
                additionalOffers.append(offer)
                
            }
            
            self.offers += additionalOffers
            self.isLoading = false
            
            completion?()
        })
    }
    
    func getNewOffers(q: String, waiting: (() -> ())?, completion: (() -> ())?){
        let url = baseUrl + "q=" + q + "&page=" + String(1)
        let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        var additionalOffers = [Offer]()
        
        waiting?()
        
        isLoading = true
        
        Alamofire.request(encodeUrl!, method: .get).responseJSON(completionHandler: {response in
            
            guard let object = response.result.value else {
                return
            }
            
            let json = JSON(object)
            
            for company in json["data"] {
                var offer = Offer()
                offer.title = company.1["title"].string
                offer.name = company.1["company"]["name"].string
                offer.description = company.1["description"].string
                
                offer.headerImagePath = company.1["image"]["i_320_131"].string
                offer.imagePath = company.1["image"]["i_50_50_x2"].string
                offer.looking_for = company.1["looking_for"].string
                offer.avatarPath = company.1["company"]["avatar"]["s_100"].string
                
                additionalOffers.append(offer)
            }
            
            self.offers = additionalOffers
            self.isLoading = false
            
            completion?()
        })
    }
}
