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
//                self.LoadingView.loadingIndicator.startAnimating()
                self.postsTable.alpha = 0.0
            } else {
//                self.LoadingView.loadingIndicator.stopAnimating()
                self.postsTable.alpha = 1.0
            }
        }
        
        self.postsTable.alpha = 0.0
        
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
        
        navigateToOtherView()
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
    
    // Set hight of the row 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func btnPostTapped(cell: PostsTableViewCell){
        let indexPath = self.postsTable.indexPath(for: cell)
        print(indexPath!.row)
        self.postPath = indexPath

    }
    
    private func navigateToOtherView(){
        let commentsVC = UIViewController(nibName: "CommentsTableViewController", bundle: nil)
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    
}
