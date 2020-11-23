//
//  PostsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class PostsTableViewController: UIViewController,PostsCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets

    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var LoadingView: LoadingView!
    
    //MARK: Properties
    
    // This variable is used when picking user on comments on cell
    var postPath : IndexPath!
    let viewModel = PostsViewModel(client: JSONPlaceholderClient())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewModel.showLoading = {
            if self.viewModel.isLoading{
                self.postsTable.alpha = 0.0
            } else {
                self.postsTable.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
            
        }
        
        viewModel.reloadData = {
            self.postsTable.reloadData()
        }
        
        viewModel.fetchUsers()
        print("Users fetched! )")
        viewModel.fetchComments()
        print("Comments fetched!)")
        viewModel.fetchPosts()
        print("Posts fetched!)")
        
        postsTable.dataSource = self
        postsTable.delegate = self
        
        let nibName = UINib(nibName: "PostsTableViewCell", bundle: nil)
        postsTable.register(nibName, forCellReuseIdentifier: "PostsTableViewCell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Posts: \(viewModel.postsCellViewModels.count)")
        return viewModel.postsCellViewModels.count
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PostsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            fatalError("The dequeue cell is not an instance of \(cellIdentifier)")
        }
        let post = viewModel.postsCellViewModels[indexPath.row]
        
        cell.delegate = self
        cell.commonInit(titleText: post.post.title, bodyText: post.post.body, userName: post.user.username, commentsCount: viewModel.commentsCount(PostId: post.post.id))
        
        
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
            commentsVC.comments = viewModel.findCommensByPostId(PostId: viewModel.postsCellViewModels[postPath.row].post.id)
        case "PostDetailsSegue":
            guard let postVC = segue.destination as?
                PostViewController else {
                     fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let selectedPostCell = sender as? PostsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            guard let indexPath = postsTable.indexPath(for: selectedPostCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            postVC.post = viewModel.postsCellViewModels[indexPath.row]
        case "fromPostUserDetailsSegue":
            guard let userVC = segue.destination as?
                UserDetailsViewController else {
                     fatalError("Unexpected sender: \(String(describing: sender)) ")
            }
            userVC.user = viewModel.findUserByUserId(UserId: viewModel.postsCellViewModels[postPath.row].post.userId)
            
        default:
            fatalError("Unexpected Segue Indentifier; \(String(describing: segue.identifier))")
        
        }
    }
        
    func btnPostTapped(cell: PostsTableViewCell){
        let indexPath = self.postsTable.indexPath(for: cell)
        print(indexPath!.row)
        self.postPath = indexPath
    }
    
    
}
