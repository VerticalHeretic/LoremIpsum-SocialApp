//
//  PostsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit


class PostsTableViewController: UITableViewController {

    //MARK: Properties
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
        

        Api().fetchUsers { users in
            self.users = users
        }
        Api().fetchPostsData{ posts in
            self.posts = posts
        }
        Api().fetchComments { comments in
            self.comments = comments
        }
        tableView.dataSource = self
        
        super.viewDidLoad()
       
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data 
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
        let user = findUserByUserId(UserId: post.userId)
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        cell.userLabel.text = user.username
        cell.commentsCountLabel.text = String(commentsCount(PostId: post.id))
        
        cell.selectionStyle = .none
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch(segue.identifier ?? "") {
        case "fromPostCommentsSegue":
            guard let commentsVC = segue.destination as?
                CommentsTableViewController else {
                    fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            commentsVC.comments = self.comments
        case "fromPostUserSegue":
            guard let userVC = segue.destination as?
                UserDetailsViewController else {
                    fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let selectedPostCell = sender as? PostsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let indexPath = tableView.indexPath(for: selectedPostCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            userVC.user = findUserByUserId(UserId: posts[indexPath.row].userId)
        case "postDetailSegue": 
            guard let postVC = segue.destination as?
                PostViewController else {
                    fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let selectedPostCell = sender as? PostsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let indexPath = tableView.indexPath(for: selectedPostCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            postVC.post = posts[indexPath.row]
        default:
            fatalError("Unexpected Segue Indentifier; \(String(describing: segue.identifier))")
        
        }
    }
    
        @IBAction func CommentsTap(_ sender: UIButton) {
            performSegue(withIdentifier: "fromPostCommentsSegue", sender: self)
        }
        
        @IBAction func UserImageTap(_ sender: Any) {
            performSegue(withIdentifier: "fromPostUserSegue", sender: self)
        }
    
    //MARK: Supporting Methods
    
    //TODO: Look on this function deeper while it sometimes do not hit the time and indexes out of range
    func findUserByUserId(UserId:Int) -> User{
        for user in users {
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
    
    @objc func tapclick(){
        print("This works for me")
        let user = storyboard?.instantiateViewController(withIdentifier: "IDUserDetailsViewController")
        navigationController?.pushViewController(user!, animated: true)
    }
    
    
  
}




