//
//  PostsTableViewCell.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

protocol PostsCellDelegate: AnyObject {
    func btnCommentsTapped(cell: PostsTableViewCell)
}

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
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
        delegate?.btnCommentsTapped(cell: self)
    }

    
    
}
