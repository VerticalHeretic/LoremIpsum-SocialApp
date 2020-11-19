//
//  PhotosCollectionViewController.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 16/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit
import os

class PhotosViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {
    
    //MARK: Outlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    
    
    var user : User!
    let viewModel = PhotosViewModel(client: JSONPlaceholderClient())
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
                self.photosCollectionView.alpha = 0.0
            } else {
                self.activityIndicator.stopAnimating()
                self.photosCollectionView.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
        }
        
        viewModel.reloadData = {
            self.photosCollectionView.reloadData()
        }
        
        viewModel.fetchPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photosCellViewModels.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PhotosCollectionViewCell
        let image = viewModel.photosCellViewModels[indexPath.item].image
        cell.photoImageView.image = image
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }
      
    
}

//MARK: Flow layout delegate

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 10
        let cellSpacing : CGFloat = 5
        
        
        return CGSize(width: (width/numberOfColumns) - (xInsets + cellSpacing), height: CGFloat(width/numberOfColumns) - (xInsets + cellSpacing))
    }
    
}
