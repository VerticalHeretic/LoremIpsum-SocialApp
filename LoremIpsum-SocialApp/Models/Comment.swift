//
//  Comment.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

struct Comment : Codable{
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
