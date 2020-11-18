//
//  PhotosViewModel.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 18/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit


struct PhotosCellViewModel {
    let image: UIImage
}

class PhotosViewModel {
    //MARK: Properties
    
    private let client: APIClient
    private var photos: [Photo] = []
}
