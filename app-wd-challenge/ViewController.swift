//
//  ViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/21.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let url = "https://www.wantedly.com/api/v1/projects?q=swift&page=1"
    var offers = [Offer]()
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブル
        table.frame = view.frame
        table.rowHeight = 200.0
        view.addSubview(table)
        table.dataSource = self
        
        offers = ApiClient().getOffers(url: url)
        
        for offer in offers{
            print(offer.name)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = offers[indexPath.row].title
        cell.detailTextLabel?.text = offers[indexPath.row].title?.description

        cell.imageView?.image = UIImage.init(named: "cl")
        
        return cell
    }
}

