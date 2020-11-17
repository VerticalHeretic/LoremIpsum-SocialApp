//
//  PostsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController,PostsCellDelegate {
    
    //MARK: Outlets
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var gradientView: ThreePointGradientView!
    
    //MARK: Properties
    
    // This variable is used when picking user on comments on cell
    var postPath : IndexPath!
    
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

        showLoadingScreen()
        
        Api().fetchUsers{ users in
            self.users = users
        }
        Api().fetchPostsData{ posts in
            self.posts = posts
        }
        Api().fetchComments{ comments in
            self.comments = comments
        }
        
        tableView.dataSource = self
        tableView.delegate = self
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
            commentsVC.comments = findCommensByPostId(PostId: posts[postPath.row].id)
        case "PostDetailsSegue":
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
        case "fromPostUserDetailsSegue":
            guard let userVC = segue.destination as?
                UserDetailsViewController else {
                     fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            userVC.user = findUserByUserId(UserId: posts[postPath.row].userId)
            
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
    
    func btnPostTapped(cell: PostsTableViewCell){
        let indexPath = self.tableView.indexPath(for: cell)
        print(indexPath!.row)
        self.postPath = indexPath
    }
    
    
    func showLoadingScreen() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // size.width have a setter, and view.bound.width is read only that's why I'm doing it like that
        loadingView.bounds.size.width = view.bounds.width
        loadingView.bounds.size.height = view.bounds.height
        
        
        //This will center loading view to the parent view (super view)
        loadingView.center = view.center
        
        //This will make the view transparent
        loadingView.alpha = 0
        
        
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
            self.loadingView.alpha = 1
        }) {(success) in
            self.animateGradientView()
        }
        
    }
    
    func animateGradientView() {
        UIView.animate(withDuration: 1, delay: 0.2, options: [],
                       animations: {
            self.gradientView.transform =
                CGAffineTransform(translationX: 0, y: -1000)
        }, completion: { (success) in
            self.hideLoadingScreen()
        })
    }
    
    func hideLoadingScreen() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.loadingView.transform = CGAffineTransform(translationX: 0, y: 10)
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                 self.loadingView.transform = CGAffineTransform(translationX: 0, y: -1000)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
        })
        }
    }
}
