//
//  Address.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//
import Foundation

struct Address : Codable{
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
}
