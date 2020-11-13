//
//  ViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    
    var post : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
        
        // Do any additional setup after loading the view.
    }


}

