//
//  Todo.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

typealias Todos = [Todo]

struct Todo : Codable{
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
