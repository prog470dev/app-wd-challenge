//
//  MainViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/24.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    var count = 1
    var isUseMaxIdex = false
    
    var indicatorView: NVActivityIndicatorView!
    
    var loadDataObserverStart: NSObjectProtocol?
    var loadDataObserverComplete: NSObjectProtocol?
    
    //追加機能
    var keysWindow: UILabel!
    var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "キーワードを入力してください"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tableView.tableHeaderView = searchBar
        
        //ローディング
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height/2 - 50, width: 100, height: 100),
                                                type: NVActivityIndicatorType.ballPulse,
                                                color: UIColor.gray)
        
        if(ApiClient.instanc.offers.count == 0){
            ApiClient.instanc.getOffers(q: "",
                                        page: count,
                                        waiting: {
                                            self.view.addSubview(self.indicatorView)
                                            self.indicatorView.startAnimating()
                                        },
                                        completion: {
                                            self.tableView.reloadData()
                                            self.indicatorView.stopAnimating()
                                            self.indicatorView.removeFromSuperview()
            })
        }
        
//        loadDataObserverStart = NotificationCenter.default.addObserver(
//            forName: .apiLoadStart,
//            object: nil,
//            queue: nil,
//            using: { notification in
//                self.view.addSubview(self.indicatorView)
//                self.indicatorView.startAnimating()
//        })
//
//        loadDataObserverComplete = NotificationCenter.default.addObserver(
//            forName: .apiLoadComplete,
//            object: nil,
//            queue: nil,
//            using: { notification in
//                self.tableView.reloadData()
//                self.indicatorView.stopAnimating()
//                self.indicatorView.removeFromSuperview()
//        })
        
        //追加機能のための処理
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.cellLongPressed(recognizer:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 0.3
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //追加機能のための処理
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath == nil {
            //nope
        } else if recognizer.state == UIGestureRecognizerState.began  {
            keysWindow = makeKeyWindow(index: (indexPath?.row)!)
            
            let px = recognizer.location(in: self.view).x
            let py = recognizer.location(in: self.view).y
            
            var nx: CGFloat = px - keysWindow.frame.width - 30.0
            var ny: CGFloat = py - keysWindow.frame.height - 30.0
            if(nx < 0.0){
                nx = px + 30.0
            }
            if(ny < 0.0){
                ny = 40.0
            }
            keysWindow.frame = CGRect(x: nx, y: ny, width: keysWindow.frame.width, height: keysWindow.frame.height)
            
            backView = UIView(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height))
            backView.backgroundColor = UIColor.gray
            backView.alpha = 0.0
            keysWindow.alpha = 0.0
            keysWindow.center.y += 3
            UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [], animations: {() -> Void in
                self.backView.alpha = 0.3
                self.keysWindow.alpha = 1.0
                self.keysWindow.center.y -= 3
            }, completion: nil)
            self.view.addSubview(backView)
            self.view.addSubview(keysWindow)
            
        } else if(recognizer.state == UIGestureRecognizerState.ended){
            backView.removeFromSuperview()
            keysWindow.removeFromSuperview()
        }
    }
    
    
    func makeKeyWindow(index: Int) -> UILabel{
        let keys = TechKeyFinder().extractionKeys(description: ApiClient.instanc.offers[index].description!)
        var ret = ""
        for var i in 0..<keys.count {
            ret += keys[i]
            if(i+1 != keys.count){
                ret += "\n"
            }
        }
        var retlabel = UILabel(frame: CGRect(x: 0,y: 0,width: 10000,height: 10000))
        retlabel.numberOfLines = 0
        retlabel.text = ret
        retlabel.sizeToFit()
        retlabel.frame = CGRect(x: 0,y: 0, width: retlabel.frame.width+10, height: retlabel.frame.height+10)
        retlabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        retlabel.textColor = UIColor.white
        retlabel.textAlignment = .center
        
        retlabel.layer.masksToBounds = true
        retlabel.layer.cornerRadius = 5.0
        retlabel.center.x = self.view.center.x
        retlabel.center.y = self.view.center.y
        
        retlabel.layer.shadowOpacity = 0.5;
        retlabel.layer.shadowRadius = 5.0;
        
        return retlabel
    }
    
    
    // MARK: - UITableViewDataDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: UIViewController = UINavigationController(rootViewController: DetailViewController(offer: ApiClient.instanc.offers[indexPath.row]))
        detailViewController.modalTransitionStyle = .crossDissolve
        self.present(detailViewController, animated: true, completion: nil)
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
                //ApiClient.instanc.getOffers(q: "Swift", page: count)
                ApiClient.instanc.getOffers(q: searchBar.text!,
                                            page: count,
                                            waiting: {
                                                self.view.addSubview(self.indicatorView)
                                                self.indicatorView.startAnimating()
                },
                                            completion: {
                                                self.tableView.reloadData()
                                                self.indicatorView.stopAnimating()
                                                self.indicatorView.removeFromSuperview()
                })
                isUseMaxIdex = false
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferItem") as! TableViewCell

        cell.taglabel.text = ApiClient.instanc.offers[indexPath.row].looking_for
        cell.titleLabel.text = ApiClient.instanc.offers[indexPath.row].title
        cell.descriptLabel.text = ApiClient.instanc.offers[indexPath.row].description
        cell.nameLabel.text = ApiClient.instanc.offers[indexPath.row].name
        
        if let imagePath = ApiClient.instanc.offers[indexPath.row].headerImagePath {
            cell.offerImage.sd_setImage(with: URL(string: imagePath),
                                        placeholderImage: UIImage(named: "loading"),
                                        options: .retryFailed)
        }else{
            cell.offerImage.image = UIImage(named: "loading")
        }
        
        if let imagePath = ApiClient.instanc.offers[indexPath.row].avatarPath {
            cell.avatarImageView.sd_setImage(with: URL(string: imagePath),
                                         placeholderImage: UIImage(named: "loading"),
                                         options: .retryFailed)
        }else{
            cell.avatarImageView.image = UIImage(named: "loading")
        }
        
        return cell
    }

    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ApiClient.instanc.getNewOffers(q: searchBar.text!,
                                       waiting: {
                                        self.view.addSubview(self.indicatorView)
                                        self.indicatorView.startAnimating()
                                        },
                                       completion: {
                                        self.tableView.reloadData()
                                        self.indicatorView.stopAnimating()
                                        self.indicatorView.removeFromSuperview()
        })
        print(searchBar.text!)
        self.view.endEditing(true)
    }

}
