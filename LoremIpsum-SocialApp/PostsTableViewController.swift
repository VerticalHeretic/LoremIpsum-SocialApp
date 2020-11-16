//
//  PostsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController,PostsCellDelegate {
    
    
    //MARK: Properties
    var commentsPostPath : IndexPath!
    
    var posts : [Post] = []
    {
        didSet
        {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var users : [User] = []
       {
          didSet
           {
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
    
    var comments : [Comment] = []
       {
           didSet
           {
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Api().fetchPostsData{ posts in
            self.posts = posts
        }
        Api().fetchUsers{ users in
            self.users = users
        }
        Api().fetchComments{ comments in
            self.comments = comments
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PostsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            fatalError("The dequeue cell is not an instance of \(cellIdentifier)")
        }
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        cell.userLabel.text = findUserByUserId(UserId: post.userId).username
        cell.commentsCount.text = String(commentsCount(PostId: post.id))
        cell.delegate = self
        
        return cell
        }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? "") {
        case "fromPostCommentsSegue":
            guard let commentsVC = segue.destination as?
                CommentsTableViewController else {
                    fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            commentsVC.comments = findCommensByPostId(PostId: posts[commentsPostPath.row].id)
        default:
            fatalError("Unexpected Segue Indentifier; \(String(describing: segue.identifier))")
        
        }
    }
    
    //MARK: Supporting Methods
    
    //TODO: Look on this function deeper while it sometimes do not hit the time and indexes out of range
    func findUserByUserId(UserId:Int) -> User{
        for user in self.users {
            if(user.id == UserId){
                return user
            }
        }
        return users[0]
    }
    
    func commentsCount(PostId:Int) -> Int{
        var counter = 0
        for comment in comments {
            if(comment.postId == PostId){
                counter += 1
            }
        }
        return counter
    }
    
    func findCommensByPostId(PostId:Int) -> [Comment]{
        var postComments : [Comment] = []
        for comment in self.comments {
            if(comment.postId == PostId){
                postComments.append(comment)
            }
        }
        return postComments
    }
    
    func btnCommentsTapped(cell: PostsTableViewCell){
        let indexPath = self.tableView.indexPath(for: cell)
        print(indexPath!.row)
        self.commentsPostPath = indexPath
    }
    
    
    
}
