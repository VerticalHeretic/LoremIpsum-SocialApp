//
//  Endpoint.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 18/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl : String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get}
}

extension Endpoint {
    var urlComponent : URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        
        return urlComponent!
    }
    
    var request: URLRequest {
        print(urlComponent.url!)
        return URLRequest(url: urlComponent.url!)
    }
    
}


enum JsonPlaceHolderEndpoint : Endpoint {
    
    case posts
    case users
    case user
    case comments
    case albums(userId: String)
    case photos(albumId: String)
    
    
    var baseUrl: String {
        return Bundle.stringValue(forKey: "primaryURL")
    }
    
    var path : String {
        switch self {
        case .posts:
            return "/posts"
        case .users:
            return "/users"
        case .user:
            return "/users"
        case .comments:
            return "/comments"
        case .albums:
            return "/albums"
        case .photos:
            return "/photos"
        }
    }
    
    var urlParameters: [URLQueryItem] {
        switch self {
        case .posts:
            return [
                
            ]
        case .users:
            return [
                
            ]
        case .user:
            return [
                URLQueryItem(name: "", value: "")
            ]
        case .comments:
            return [
                
            ]
        case .albums(let userId):
            return [
                URLQueryItem(name: "userId", value: userId )
            ]
        case .photos(let albumId):
            return [
                URLQueryItem(name: "albumId", value: albumId)
            ]
        }
    }
}


extension Bundle
{
 static func stringValue(forKey key: String) -> String
 {
    guard let value = self.main.infoDictionary?[key] as? String else {
   fatalError("Couldn't find value for key \(key)")
  }
  return value
 }
}
