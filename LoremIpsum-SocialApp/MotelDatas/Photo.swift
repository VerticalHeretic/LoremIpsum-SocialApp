//
//  Photo.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 10/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import Foundation

typealias Photos = [Photo]

struct Photo : Codable{
    var albumId: Int
    var id: Int
    var title: String
    var url: URL
    var thumbnailUrl: URL
}
