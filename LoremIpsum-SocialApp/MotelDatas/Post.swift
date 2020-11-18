//
//  Post.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import SwiftUI

typealias Posts = [Post]

struct Post : Codable{
    var id : Int
    var userId : Int
    var title : String
    var body : String
}
