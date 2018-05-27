//
//  ViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/21.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var count = 1
    var isUseMaxIdex = false
    
    let table = UITableView()
    var searchBar = UISearchBar()
    var indicatorView: NVActivityIndicatorView!
    
    var loadDataObserverStart: NSObjectProtocol?
    var loadDataObserverComplete: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = view.frame
        table.rowHeight = 200.0
        table.showsVerticalScrollIndicator = false
        
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.backgroundColor = UIColor.blue
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "キーワードを入力してください"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = UIColor.blue
        table.tableHeaderView = searchBar
        
        //ローディング
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height/2 - 50, width: 100, height: 100),
                                                type: NVActivityIndicatorType.ballPulse,
                                                color: UIColor.gray)
        
        if(ApiClient.instanc.offers.count == 0){
            ApiClient.instanc.getOffers(q: "Swift", page: count)
        }
        
        loadDataObserverStart = NotificationCenter.default.addObserver(
            forName: .apiLoadStart,
            object: nil,
            queue: nil,
            using: { notification in
                self.view.addSubview(self.indicatorView)
                self.indicatorView.startAnimating()
            }
        )
        
        loadDataObserverComplete = NotificationCenter.default.addObserver(
            forName: .apiLoadComplete,
            object: nil,
            queue: nil,
            using: { notification in
                self.table.reloadData()
                self.indicatorView.stopAnimating()
                self.indicatorView.removeFromSuperview()
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
                ApiClient.instanc.getOffers(q: "Swift", page: count)
                isUseMaxIdex = false
            }
        }

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = ApiClient.instanc.offers[indexPath.row].title
        cell.detailTextLabel?.text = ApiClient.instanc.offers[indexPath.row].title?.description

        if let imagePath = ApiClient.instanc.offers[indexPath.row].imagePath {
            cell.imageView?.sd_setImage(with: URL(string: imagePath),
                                        placeholderImage: UIImage(named: "loading"),
                                        options: .retryFailed)
        }else{
            cell.imageView!.image = UIImage(named: "loading")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: UIViewController = UINavigationController(rootViewController: DetailViewController(offer: ApiClient.instanc.offers[indexPath.row]))
        detailViewController.modalTransitionStyle = .crossDissolve
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - UISearchBarDelegate

    //インクリメンタルリサーチ
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        ApiClient.instanc.getNewOffers(q: searchBar.text!)
//    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
    }
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    //検索開始時に呼び出される
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ApiClient.instanc.getNewOffers(q: searchBar.text!)
        self.view.endEditing(true)
    }
    
}

