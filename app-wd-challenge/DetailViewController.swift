//
//  DetailViewController.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/23.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    var backButton: UIBarButtonItem!
    
    init(offer: Offer){
        super.init(nibName: nil, bundle: nil)
        
        backButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(DetailViewController.back))
        self.navigationItem.leftBarButtonItem = backButton
        
//        // UIImage インスタンスの生成
//        let image1: UIImage = UIImage(named:"am.jpg")!
//        // UIImageView 初期化
//        let imageView = UIImageView(image:image1)
//        // 画面の縦横幅を取得
//        let screenWidth:CGFloat = view.frame.size.width
//        //iew.frame.size.heightが画像を一番下に（見えなくなる）
//        //-screenWidth/2-50で画像を下から50pt上に表示
//        imageView.frame = CGRect(x:0,y:view.frame.size.height-screenWidth/2-50,width: screenWidth/2, height:screenWidth/2)
//        //画面中心に画像を設定
//        imageView.center.x = self.view.center.x
//        //imageView.center.y = self.view.center.y
//
//        // UIImageViewのインスタンスをビューに追加
//        self.view.addSubview(imageView)
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

}
