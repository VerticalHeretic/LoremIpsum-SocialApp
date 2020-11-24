//
//  PostsViewModel.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 18/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit
import os

struct PostsCellViewModel {
    let post : Post
    let user : User
    let comments : [Comment]
}

class PostsViewModel {
    
    //MARK: Properties
    private let client: APIClient
    private var posts: Posts = [] {
        didSet {
            self.fetchPost()
        }
    }
    
    private var users: Users = [] {
        didSet {
            self.fetchPost()
        }
    }
    
    private var comments: Comments = [] {
        didSet {
            self.fetchPost()
        }
    }
    
    var postsCellViewModels : [PostsCellViewModel] = []
    private let dispatchGroup = DispatchGroup()
    
    //MARK: UI
    var isLoading: Bool = false {
           didSet {
               showLoading?()
           }
       }

    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    //MARK: Initialization
    init(client: APIClient) {
        self.client = client
    }
    
    
    
     func fetchPosts(){
        dispatchGroup.enter()
        os_log("PostsViewModel -> Starting posts fetching")
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.posts
            client.fetchPosts(with: endpoint) { (either) in
                switch either {
                    case .success(let posts):
                        self.posts = posts
                        os_log("PostsViewModel -> Ended posts fetching")
                        self.dispatchGroup.leave()
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }

    }
    
    
    func fetchComments(){
        dispatchGroup.enter()
        os_log("PostsViewModel -> Starting comments fetching")
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.comments
            client.fetchComments(with: endpoint) { (either) in
                switch either {
                    case .success(let comments):
                        self.comments = comments
                        os_log("PostsViewModel -> Ended comments fetching")
                        self.dispatchGroup.leave()
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }
    
     func fetchUsers(){
        dispatchGroup.enter()
        os_log("PostsViewModel -> Starting users fetching")
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.users
            client.fetchUsers(with: endpoint) { (either) in
                switch either {
                    case .success(let users):
                        self.users = users
                        os_log("PostsViewModel -> Ended users fetching")
                        self.dispatchGroup.leave()
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }
    
    
     private func fetchPost() {
        
        self.posts.forEach { (post) in
            DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                self.dispatchGroup.enter()
                
                self.postsCellViewModels.append(PostsCellViewModel(post: post, user: self.findUserByUserId(UserId: post.userId), comments: self.findCommensByPostId(PostId: post.id)))
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            os_log("PostsViewModel -> Finished fetching posts")
            self.isLoading = false
            self.reloadData?()
        }
    }
    
    
    
    //MARK: Supporting Methods
      
    func findUserByUserId(UserId:Int) -> User{
        var userPlaceholder : User!
          for user in self.users {
              if(user.id == UserId){
                  userPlaceholder = user
              }
          }

        return userPlaceholder
      }
      
    func commentsCount(PostId:Int) -> String{
          var counter = 0
        for comment in self.comments {
              if(comment.postId == PostId){
                  counter += 1
              }
          }
          return String(counter)
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
    
}
