//
//  PostsTableViewCell.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

protocol PostsCellDelegate: AnyObject {
    func btnPostTapped(cell: PostsTableViewCell)
}

class PostsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    
    weak var delegate: PostsCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    @IBAction func btnCommentsTapped(sender: UIButton) {
        delegate?.btnPostTapped(cell: self)
    }
    
    @IBAction func btnUserTapped(sender: UIButton) {
        delegate?.btnPostTapped(cell: self)
    }
    
    func commonInit(titleText: String, bodyText: String, userName: String, commentsCount: String){
        self.titleLabel.text = titleText
        self.userLabel.text = userName
        self.bodyLabel.text = bodyText
        self.commentsCount.text = commentsCount
    }
    
}
