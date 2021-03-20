//
//  FavoriteDetails.swift
//  NYTApp
//
//  Created by Виталий on 19.03.2021.
//  Copyright © 2021 Виталий. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON


class FavoriteDetails: UIViewController {
    
    @IBOutlet weak var favoriteHeaderView: UIView!
    
    @IBOutlet weak var favoriteSpacestationImage: UIImageView!
    
    @IBOutlet weak var favoriteOwnersName: UILabel!
    
    @IBOutlet weak var favoriteOwnersAbbrev: UILabel!
    
    @IBOutlet weak var favoriteDescriptionView: UIView!
    
    @IBOutlet weak var favoriteDescriptionText: UILabel!
    
    var detail: MainScreen?{
        
        didSet{
            
            navigationItem.title = detail?.describeName
            
            if let nameLabel = detail?.main?.ownersName {
                self.name = nameLabel
            }
            
            if let abbrevLabel = detail?.main?.ownersAbbrev {
                self.ownersAbbrev = abbrevLabel
            }
            
            if let descriptionLabel = detail?.main?.descriptionText {
                self.descriptionText = descriptionLabel
            }
            
            if let url = detail?.pictureName{
                self.urlPictureString = url
            }
        }
    }
    
    private var name = String()
    private var ownersAbbrev = String()
    private var descriptionText = String()
    private var urlPictureString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewLayer(name: favoriteHeaderView)
        headerViewLayer(name: favoriteDescriptionView)
        favoriteOwnersName.text = name
        favoriteOwnersAbbrev.text = ownersAbbrev
        favoriteDescriptionText.text = descriptionText
        getPicture()
    }
    
    func headerViewLayer(name: UIView){
        
        name.layer.backgroundColor = UIColor.white.cgColor
        name.layer.cornerRadius = 8
        name.layer.shadowColor = UIColor.lightGray.cgColor
        name.layer.shadowRadius = 10
        name.layer.shadowOpacity = 0.5
        name.layer.shadowOffset = CGSize(width: 0, height: 0)
        name.layer.shouldRasterize = true
    }
    
    func getPicture(){
        
        Alamofire.request("\(urlPictureString)").responseImage {
            (response) in
            
            if let image = response.result.value{
                
                DispatchQueue.main.async {
                    self.favoriteSpacestationImage.image = image
                }
            }
        }
        
    }
    
}
