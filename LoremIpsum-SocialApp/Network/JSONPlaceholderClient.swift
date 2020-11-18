//
//  JSONPlaceholderClient.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 18/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

class JSONPlaceholderClient : APIClient {
    
    static let baseUrl = Bundle.stringValue(forKey: "primaryURL")
    
    func fetchPosts(with endpoint: JsonPlaceHolderEndpoint, completion: @escaping (Either<[Post]>) -> Void){
        let request = endpoint.request
        get(with: request, completion: completion)
    }
    
}
