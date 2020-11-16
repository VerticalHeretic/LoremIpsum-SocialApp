//
//  UserDetailsViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 16/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = self.user.name
        self.emailLabel.text = self.user.email
        self.phoneLabel.text = self.user.phone
        self.websiteLabel.text = self.user.website
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
