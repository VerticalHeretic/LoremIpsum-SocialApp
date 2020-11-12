//
//  Api.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 12/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

class Api {
    
    func fetchPostsData(completionHandler : @escaping([Post]) -> Void){
        
        if let urlToServer = URL.init(string: "https://jsonplaceholder.typicode.com/posts") {
            
            let tasks = URLSession.shared.dataTask(with: urlToServer) { (data, response, error) in
                
                // This means -> If you cannot unwrap the variable continue, and if you unwrapped it just return
                guard let data = data else {return}
                           
                do {
                            
                    let postsData = try JSONDecoder().decode([Post].self, from: data)
                    completionHandler(postsData)
                    
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                    }
            }.resume()
        }

    }
    
    func fetchUsers(completionHandler : @escaping([User]) -> Void){
        
        if let urlToServer = URL.init(string: "https://jsonplaceholder.typicode.com/users") {
            
            let tasks = URLSession.shared.dataTask(with: urlToServer) { (data, response, error) in
                
                // This means -> If you cannot unwrap the variable continue, and if you unwrapped it just return
                guard let data = data else {return}
                           
                do {
                            
                    let usersData = try JSONDecoder().decode([User].self, from: data)
                    completionHandler(usersData)
                    
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                    }
            }.resume()
        }

    }
    
    func fetchComments(completionHandler : @escaping([Comment]) -> Void){
        
        if let urlToServer = URL.init(string: "https://jsonplaceholder.typicode.com/comments") {
            
            let tasks = URLSession.shared.dataTask(with: urlToServer) { (data, response, error) in
                
                // This means -> If you cannot unwrap the variable continue, and if you unwrapped it just return
                guard let data = data else {return}
                           
                do {
                            
                    let commentsData = try JSONDecoder().decode([Comment].self, from: data)
                    completionHandler(commentsData)
                    
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                    }
            }.resume()
        }
    }
    
    func fetchCommentsWithId(PostID: Int, completionHandler : @escaping([Comment]) -> Void){
        
        if let urlToServer = URL.init(string: "https://jsonplaceholder.typicode.com/comments/?postId=\(PostID)") {
            
            let tasks = URLSession.shared.dataTask(with: urlToServer) { (data, response, error) in
                
                // This means -> If you cannot unwrap the variable continue, and if you unwrapped it just return
                guard let data = data else {return}
                           
                do {
                            
                    let commentsData = try JSONDecoder().decode([Comment].self, from: data)
                    completionHandler(commentsData)
                    
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                    }
            }.resume()
        }
    }
    
}
