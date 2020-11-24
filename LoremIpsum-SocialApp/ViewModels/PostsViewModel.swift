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
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.posts
            client.fetchPosts(with: endpoint) { (either) in
                switch either {
                    case .success(let posts):
                        self.posts = posts
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }
    
    func fetchComments(){
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.comments
            client.fetchComments(with: endpoint) { (either) in
                switch either {
                    case .success(let comments):
                        self.comments = comments
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }
    
    func fetchUsers(){
        if let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.users
            client.fetchUsers(with: endpoint) { (either) in
                switch either {
                    case .success(let users):
                        self.users = users
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }

    
    
    private func fetchPost() {
        let group = DispatchGroup()
        
        self.posts.forEach { (post) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                
                self.postsCellViewModels.append(PostsCellViewModel(post: post, user: self.findUserByUserId(UserId: post.userId), comments: self.findCommensByPostId(PostId: post.id)))
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("Finished fetching posts")
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
