//
//  Api.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 12/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

enum ApiErrors:Error {
    case NoDataAvailableError
}

final class Api {
    
    static let shared = Api()
    
    func getPosts(completition: @escaping ([Post]) -> ()) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let task = URLSession.shared.dataTask(with: url) { (data,_,_) in
            
            guard let data = data else {
                print("Data was nil")
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                print("Couldn't decode json")
                return
            }
            
            completition(posts)
            
        }
        task.resume()
    }
    
}

