//
//  PhotosViewModel.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 18/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit
import os

struct PhotosCellViewModel {
    let image: UIImage
}

class PhotosViewModel {
    //MARK: Properties
    
    private let client: APIClient
    private var photos: Photos = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    var photosCellViewModels : [PhotosCellViewModel] = []
    
    //MARK: UI
    
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchPhotos() {
        if  let client = client as? JSONPlaceholderClient {
            self.isLoading = true
            let endpoint = JsonPlaceHolderEndpoint.photos(albumId: "1")
            client.fetchPhotos(with: endpoint, completion: { (either) in
                switch either {
                case .success(let photos):
                    self.photos = photos
                case .error(let error):
                    self.showError?(error)
                }
            })
        }
    }
    
    private func fetchPhoto() {
        let group = DispatchGroup() // <- this can be explained as a counter of dispatchers
        
        self.photos.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                guard let imageData = try? Data(contentsOf: photo.thumbnailUrl) else {
                    self.showError?(APIError.imageDownload)
                    return
                }
                os_log("Loading photo", log: .default, type: .debug)
                
                guard let image = UIImage(data: imageData) else {
                    self.showError?(APIError.imageConvert)
                    return
                }
                self.photosCellViewModels.append(PhotosCellViewModel(image: image))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }
}
