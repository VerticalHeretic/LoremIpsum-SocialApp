//
//  PostsTableViewCell.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 12/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var bodyLabel : UILabel!
    @IBOutlet weak var userLabel : UILabel!
    @IBOutlet weak var commentsCountLabel : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
