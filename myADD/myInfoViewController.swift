//
//  .swift
//  myADD
//
//  Created by 이융의 on 2023/07/04.
//myInfoViewController


import UIKit

class myInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
    }
    
}


