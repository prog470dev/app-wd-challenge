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
        
        print(offer.title)
        
        backButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(DetailViewController.back))
        self.navigationItem.leftBarButtonItem = backButton
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
