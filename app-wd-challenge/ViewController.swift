//
//  ViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/21.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var url = "https://www.wantedly.com/api/v1/projects?q=swift&page="
    var count = 1
    var isUseMaxIdex = false
    
    let table = UITableView()
    var searchBar = UISearchBar()
    
    var loadDataObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = view.frame
        table.rowHeight = 200.0
        table.showsVerticalScrollIndicator = false
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
//        table.refreshControl = refreshControl
        
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "キーワードを入力してください"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = UIColor.cyan
        table.tableHeaderView = searchBar
        
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

//    @objc func refresh(sender: UIRefreshControl) {
//        ApiClient.instanc.getOffers(url: url + String(count))
//        sender.endRefreshing()
//    }
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let detailViewController: UIViewController = DetailViewController(offer: ApiClient.instanc.offers[indexPath.row])
        let detailViewController: UIViewController = UINavigationController(rootViewController: DetailViewController(offer: ApiClient.instanc.offers[indexPath.row]))
        detailViewController.modalTransitionStyle = .crossDissolve
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func updateSearchResults(for searchController: UISearchController) {
        //TODO: 検索機能
    }
    
}

