//
//  DetailViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/23.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate{
    
    var backButton: UIBarButtonItem!
    var scrollView: UIScrollView!
    
    init(offer: Offer){
        super.init(nibName: nil, bundle: nil)
        
        backButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(DetailViewController.back))
        self.navigationItem.leftBarButtonItem = backButton
    
        var totalHeight:CGFloat = 0.0
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.frame.size = self.view.frame.size
        
        let myImage = UIImage(named: "loading")!
        
        //131*320
        let imageWidth:CGFloat = view.frame.width
        let imageHeight:CGFloat = 131.0 * (320.0 / imageWidth)
        
        let myImageView = UIImageView(frame:  CGRect(x: 0,
                                                     y: 0,
                                                     width: imageWidth,
                                                     height: imageHeight))
        
        if let imagePath = offer.headerImagePath {
            print(imagePath)
            myImageView.sd_setImage(with: URL(string: imagePath),
                                    placeholderImage: UIImage(named: "loading"),
                                    options: .retryFailed)
        }else{
            myImageView.image = myImage
        }
        
        totalHeight += imageHeight
        scrollView.addSubview(myImageView)
        
        //タイトル
        let title: UILabel = UILabel(frame: CGRect(x: 0, y: totalHeight + 30, width: self.view.frame.width, height: 0))
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.numberOfLines = 0
        title.text = offer.title
        title.sizeToFit()
        scrollView.addSubview(title)
        totalHeight += title.frame.height + 30
        
        //企業情報
        let avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 10, y: totalHeight + 20, width: 50, height: 50))
        if let imagePath = offer.avatarPath {
            avatarImageView.sd_setImage(with: URL(string: imagePath),
                                    placeholderImage: UIImage(named: "loading"),
                                    options: .retryFailed)
        }else{
            avatarImageView.image = UIImage(named: "loading")
        }
        //avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        let pos = 10 + avatarImageView.frame.width + 20
        scrollView.addSubview(avatarImageView)
        
        let companyName: UILabel = UILabel(frame: CGRect(x: pos, y: totalHeight + 20, width: view.frame.width - pos, height: 50))
        companyName.font = UIFont.systemFont(ofSize: 10)
        companyName.text = offer.name
        scrollView.addSubview(companyName)
        totalHeight += avatarImageView.frame.height + 20
        
        //紹介文
        let description: UILabel = UILabel(frame: CGRect(x: 0, y: totalHeight + 30, width: self.view.frame.width, height: 0))
        description.numberOfLines = 0
        description.text = offer.description
        description.sizeToFit()
        scrollView.addSubview(description)
        totalHeight += description.frame.height + 30
        
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight)
        self.view.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        //print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        //print("beginDragging")
    }

}
