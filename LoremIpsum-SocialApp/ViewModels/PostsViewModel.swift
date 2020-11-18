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
    let id : Int
    let title : String
    let body : String
    let commentsCount : String
    let username : String
}

class PostsViewModel {
    
    //MARK: Properties
    private let client: APIClient
    private var posts: Posts = [] {
        didSet {
            self.fetchPosts()
        }
    }
    
    private var users: Users = [] {
        didSet {
            self.fetchUsers()
        }
    }
    
    private var comments: Comments = [] {
        didSet {
            self.fetchComments()
        }
    }
    
    var postsCellViewModels : [PostsCellViewModel] = []
    
    //MARK: UI
    var isLoading: Bool = false {
        didSet{
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
            let endpoint = JsonPlaceHolderEndpoint.comments
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
        let group = DispatchGroup() // <- this can be explained as a counter of dispatchers
        
        self.posts.forEach { (post) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                
                
                os_log("Loading post", log: .default, type: .debug)
                
                self.postsCellViewModels.append(PostsCellViewModel(id: post.id, title: post.title, body: post.body, commentsCount: self.commentsCount(PostId: post.id), username: self.findUserByUserId(UserId: post.userId)!.username))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }
    
    //MARK: Supporting Methods
      
      
        func findUserByUserId(UserId:Int) -> User?{
          for user in self.users {
              if(user.id == UserId){
                  return user
              }
          }
          return nil
      }
      
      private func commentsCount(PostId:Int) -> String{
          var counter = 0
          for comment in comments {
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
