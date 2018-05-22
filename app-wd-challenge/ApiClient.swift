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

class ApiClient {
 
    func getOffers(url: String) -> [Offer] {
        var offers = [Offer]()
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        Alamofire.request(url, method: .get).responseJSON(queue: queue, completionHandler: {response in
            
            guard let object = response.result.value else {
                return
            }
            
            let json = JSON(object)
            
            for company in json["data"] {
                var offer = Offer()
                offer.title = company.1["title"].string
                offer.name = company.1["company"]["name"].string
                offer.description = company.1["description"].string
                
                offers.append(offer)
            }
            
            print("completionHandler")
            semaphore.signal()
        })
        
        semaphore.wait()
        print("return offers")
        return offers
    }
}
