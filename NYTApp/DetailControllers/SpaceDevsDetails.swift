//
//  SpaceDevsDetails.swift
//  NYTApp
//
//  Created by Виталий on 3/4/21.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreData

class SpaceDevsDetails: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var spacestationImage: UIImageView!
    
    @IBOutlet weak var ownersName: UILabel!
    
    @IBOutlet weak var ownersAbbrev: UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    var name = String()
    
    var descrName = String()
    
    var urlString = String()
    
    var urlPicture = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(urlString)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to favorite", style: .plain, target: self, action: #selector (favoriteButton(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)

        
        headerViewLayer(name: headerView)
        headerViewLayer(name: descriptionView)
        getReqest()
        

    }
    
    private func getReqest(){
        
        Alamofire.request("\(urlString)").responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(_):
                if let responseStr = response.result.value{
                    let jsonResponse = JSON(responseStr)
                    
                    self.name = jsonResponse["spacestation"]["name"].stringValue
                    self.descrName = jsonResponse["name"].stringValue

                    let jsonResults = jsonResponse["spacestation"]["owners"].array!
                    
                    for jsonRes in jsonResults{
                        
                        self.ownersName.text = jsonRes["name"].stringValue
                        self.ownersAbbrev.text = jsonRes["abbrev"].stringValue
                       }
                    let urlImage = jsonResponse["spacestation"]["image_url"].stringValue
                    
                    self.urlString = urlImage
                    self.descriptionText.text = jsonResponse["spacestation"]["description"].stringValue
                    
                    DispatchQueue.main.async {
                        Alamofire.request("\(urlImage)").responseImage {
                            (response) in
                            
                            if let image = response.result.value{
                                
                                self.spacestationImage?.image = image
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
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
    
    @objc func favoriteButton(sender: UIButton){
        
            let delegate = UIApplication.shared.delegate as? AppDelegate
            
            if let context = delegate?.persistentContainer.viewContext {
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: "MainScreen", into: context) as! MainScreen
                entity.nameLabel = self.name
                entity.describeName = self.descrName
                entity.pictureName = self.urlString

                
                let describe = NSEntityDescription.insertNewObject(forEntityName: "DetailScreen", into: context) as! DetailScreen
                describe.detail = entity
                describe.ownersName = self.ownersName.text
                describe.ownersAbbrev = self.ownersAbbrev.text
                describe.descriptionText = self.descriptionText.text
                

                do{
                    try(context.save())
                                        
                }catch let err{
                    print(err)
                }
            }

    }

    
}
