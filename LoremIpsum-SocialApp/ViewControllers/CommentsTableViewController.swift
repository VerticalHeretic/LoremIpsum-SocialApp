//
//  CommentsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 16/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class CommentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var postId : Int!
    var comments : [Comment] = []
    
    //MARK: Outlets
    @IBOutlet weak var commentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(comments)
        
        let nibName = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        commentsTable.register(nibName, forCellReuseIdentifier: "CommentsTableViewCell")
        
        commentsTable.dataSource = self
        commentsTable.delegate = self
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CommentsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommentsTableViewCell else {
            fatalError("The dequeue cell is not an instance of \(cellIdentifier)")
        }
        print(cell)
        let comment = comments[indexPath.row]
        cell.bodyLabel.text = comment.body
        cell.titleLabel.text = comment.name
        cell.commenterLabel.text = "By: \(comment.email)"


        return cell
    }
   

}
