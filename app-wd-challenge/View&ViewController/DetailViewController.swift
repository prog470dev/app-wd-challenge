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
    
    var offer: Offer!
    
    init(offer: Offer){
        super.init(nibName: nil, bundle: nil)
        
        self.offer = offer
        
        backButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(DetailViewController.back))
        self.navigationItem.leftBarButtonItem = backButton
    
        var totalHeight:CGFloat = 0.0
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.frame.size = self.view.frame.size
        
        //131*320
        let imageWidth:CGFloat = view.frame.width
        let imageHeight:CGFloat = 131.0 * (320.0 / imageWidth)
        
        let headerImageView = UIImageView(frame:  CGRect(x: 0,
                                                     y: 0,
                                                     width: imageWidth,
                                                     height: imageHeight))
        
        if let imagePath = offer.headerImagePath {
            print(imagePath)
            headerImageView.sd_setImage(with: URL(string: imagePath),
                                    placeholderImage: UIImage(named: "loading"),
                                    options: .retryFailed)
        }else{
            headerImageView.image = UIImage(named: "loading")
        }
        
        totalHeight += imageHeight
        scrollView.addSubview(headerImageView)
        
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
        
        totalHeight += 100   //応募フォームのための空間
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight)
        self.view.addSubview(scrollView)
        
        //応募UI
        let applicationLabel: UIButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 300/2,
                                                   y: self.view.frame.height - 50 - 20,
                                                   width: 300,
                                                   height: 50))
        applicationLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        applicationLabel.layer.masksToBounds = true
        applicationLabel.layer.cornerRadius = 20.0
        applicationLabel.setTitle("話を聞きに行きたい", for: .normal)
        applicationLabel.setTitleColor(UIColor.white, for: .normal)
        applicationLabel.addTarget(self, action: #selector(DetailViewController.onClickApplication(sender:)), for: .touchUpInside)
        self.view.addSubview(applicationLabel)
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
    
    @objc func onClickApplication(sender: UIButton) {

        let alertSheet = UIAlertController(title: self.offer.name,
                                           message: self.offer.title,
                                           preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "今すぐ一緒に働きたい", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            //TODO: ここでエントリーの最終確認
        })
        let action2 = UIAlertAction(title: "まずは話を聞いてみたい", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
        })
        let action3 = UIAlertAction(title: "少しだけ興味があります", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
        })
        let action4 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        alertSheet.addAction(action4)
        
        self.present(alertSheet, animated: true, completion: nil)
    }

}
