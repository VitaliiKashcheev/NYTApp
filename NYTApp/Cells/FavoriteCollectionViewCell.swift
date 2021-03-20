//
//  FavoriteCollectionViewCell.swift
//  NYTApp
//
//  Created by Виталий on 19.03.2021.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var detail: DetailScreen? {
        didSet{
            
            favoriteNameLabel.text = detail?.detail?.nameLabel
            
            favoriteDescrLabel.text = detail?.detail?.describeName
            
            if let profileImageName = detail?.detail?.pictureName{
            self.urlString = profileImageName
            }
            
            Alamofire.request("\(urlString)").responseImage {
                (response) in
                
                if let image = response.result.value{
                    
                    DispatchQueue.main.async {
                        self.favoriteMainPicture.image = image
                    }
                }
            }
            
            
        }
    }
    
    var urlString = String()
    
    
    @IBOutlet weak var favoriteMainPicture: UIImageView!
    
    @IBOutlet weak var favoriteNameLabel: UILabel!
    
    @IBOutlet weak var favoriteDescrLabel: UILabel!
    
    
}
