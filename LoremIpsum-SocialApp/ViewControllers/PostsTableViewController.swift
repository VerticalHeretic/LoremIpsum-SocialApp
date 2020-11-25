//
//  PostsTableViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 13/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit


class PostsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,PostsCellDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var postsTable: UITableView!
    
    
    //MARK: Properties
    
    // This variable is used when picking user on comments on cell
    var postPath : IndexPath!
    let viewModel = PostsViewModel(client: JSONPlaceholderClient())
    let mainColor = UIColor(displayP3Red: 255.0, green: 98.0, blue: 0.0, alpha:1.0 )
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let style = UINavigationBarAppearance()
            style.configureWithDefaultBackground()
            style.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.standardAppearance = style
            self.navigationController?.navigationBar.compactAppearance = style
            
            //Cofiguration of large style
            let largeStyle = UINavigationBarAppearance()
            largeStyle.configureWithTransparentBackground()
            largeStyle.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 36), .foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.scrollEdgeAppearance = largeStyle
        }
        
        self.title = "Posts"
        
        
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        self.view.addSubview(loadingView)
        
        viewModel.showLoading = {
            if self.viewModel.isLoading{
                loadingView.loadingIndicator.startAnimating()
                self.postsTable.alpha = 0.0
                self.navigationController?.navigationBar.isHidden = true
            } else {
                loadingView.loadingIndicator.stopAnimating()
                loadingView.alpha = 0.0
                self.postsTable.alpha = 1.0
                self.navigationController?.navigationBar.isHidden = false
            }
        }
        
        
        viewModel.showError = { error in
            print(error)
            
        }
        
        viewModel.reloadData = {
            self.postsTable.reloadData()
        }
        
        
        viewModel.fetchUsers()
        viewModel.fetchComments()
        viewModel.fetchPosts()
        
        postsTable.dataSource = self
        postsTable.delegate = self
        
        let nibName = UINib(nibName: "PostsTableViewCell", bundle: nil)
        postsTable.register(nibName, forCellReuseIdentifier: "PostsTableViewCell")
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = PostViewController()
        postVC.post = viewModel.postsCellViewModels[indexPath.row]
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    // Set hight of the row 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func btnCommentsTapped(cell: PostsTableViewCell){
        let indexPath = self.postsTable.indexPath(for: cell)
        print(indexPath!.row)
        self.postPath = indexPath
        
        let commentsVC = CommentsTableViewController()
        commentsVC.comments = self.viewModel.findCommensByPostId(PostId: viewModel.postsCellViewModels[postPath.row].post.userId)

        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func btnUserTapped(cell: PostsTableViewCell) {
        let indexPath = self.postsTable.indexPath(for: cell)
        print(indexPath!.row)
        self.postPath = indexPath
        
        let userVC  = UserDetailsViewController()
        userVC.user = viewModel.findUserByUserId(UserId: viewModel.postsCellViewModels[postPath.row].post.userId)
 
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    
    
    
}
