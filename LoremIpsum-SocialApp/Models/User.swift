//
//  User.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

struct User : Codable{
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}

