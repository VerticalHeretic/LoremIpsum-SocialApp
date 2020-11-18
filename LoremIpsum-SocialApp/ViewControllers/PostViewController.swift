//
//  PostViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 16/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    //MARK: Properties
    var post : PostsCellViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post: \(self.post.id)"
        self.titleLabel.text = self.post.title
        self.bodyLabel.text = self.post.body

        // Do any additional setup after loading the view.
    }
    
       //MARK: Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    

    


}
