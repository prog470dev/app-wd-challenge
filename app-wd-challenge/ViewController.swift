//
//  ViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/21.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var url = "https://www.wantedly.com/api/v1/projects?q=swift&page="
    var count = 1
    var isUseMaxIdex = false
    
    let table = UITableView()
    
    var loadDataObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = view.frame
        table.rowHeight = 200.0
        view.addSubview(table)
        table.dataSource = self
        
        if(ApiClient.instanc.offers.count == 0){
            ApiClient.instanc.getOffers(url: url + String(count))
        }
        
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .apiLoadComplete,
            object: nil,
            queue: nil,
            using: { notification in
                self.table.reloadData()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApiClient.instanc.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(ApiClient.instanc.offers.count < indexPath.row + 3){
            //TODO: もっと適切なやり方があるはず
            if(!isUseMaxIdex){  //テーブルのリロード時にindexPathが自動的にリストの最大値になるため連続してAPIが呼ばれる現象への対処
                isUseMaxIdex = true
            }else{
                count += 1
                ApiClient.instanc.getOffers(url: url + String(count))

                isUseMaxIdex = false
            }
        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = ApiClient.instanc.offers[indexPath.row].title//offers[indexPath.row].title
        cell.detailTextLabel?.text = ApiClient.instanc.offers[indexPath.row].title?.description //offers[indexPath.row].title?.description

        cell.imageView?.image = UIImage.init(named: "cl")
        
        return cell
    }
    
    
}

