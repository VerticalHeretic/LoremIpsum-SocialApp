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
    let viewModel = PostsViewModel(client: JSONPlaceholderClient())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoadingScreen()
        
        viewModel.showLoading = {
            if self.viewModel.isLoading{
                self.tableView.alpha = 0.0
            } else {
                self.tableView.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
            
        }
        
        viewModel.reloadData = {
            self.tableView.reloadData()
        }
        
        viewModel.fetchUsers()
        print("Users fetched! )")
        viewModel.fetchComments()
        print("Comments fetched!)")
        viewModel.fetchPosts()
        print("Posts fetched!)")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.postsCellViewModels.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PostsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            fatalError("The dequeue cell is not an instance of \(cellIdentifier)")
        }
        let post = viewModel.postsCellViewModels[indexPath.row]
        
        cell.titleLabel.text = post.post.title
        cell.bodyLabel.text = post.post.body
        cell.userLabel.text = post.user.username
        cell.commentsCount.text = viewModel.commentsCount(PostId: post.post.id)
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
            commentsVC.comments = viewModel.findCommensByPostId(PostId: viewModel.postsCellViewModels[postPath.row].post.id)
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
