//
//  ViewController3.swift
//  NYTApp
//
//  Created by Виталий on 2/25/21.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage


class SpaceDevsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var spaceCollection: UICollectionView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let url = "https://lldev.thespacedevs.com/2.2.0/expedition/"
    
    var spaceDataArray: [SpaceDataStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.spaceCollection.dataSource = self
        self.spaceCollection.delegate = self
        
        self.getReqest()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceDataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! SpaceDevsCollectionViewCell
        
        cell.nameLabel?.text = spaceDataArray[indexPath.row].nameLabel
        cell.descrLabel?.text = spaceDataArray[indexPath.row].descrLabel
        let urlImage = spaceDataArray[indexPath.row].urlImage
        
        Alamofire.request("\(urlImage)").responseImage {
            (response) in
            
            if let image = response.result.value{
                
                DispatchQueue.main.async {
                    cell.mainScreenPicture?.image = image
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        performSegue(withIdentifier: "showDetailSpace", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.spaceCollection?.indexPathsForSelectedItems?.first?.row {
            let name = spaceDataArray[indexPath].detailUrl
            if let destination = segue.destination as? SpaceDevsDetails {
            destination.urlString = name
            }
        }
    }
}


extension SpaceDevsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 80)
        return size
    }
}


extension SpaceDevsViewController {
    
    private func getReqest(){
        
        Alamofire.request("\(url)").responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(_):
                if let responseStr = response.result.value{
                    let jsonResponse = JSON(responseStr)
                    let jsonResults = jsonResponse["results"].array!
                    
                    self.spaceDataArray.removeAll()
                    
                    for jsonR in jsonResults{
                        
                        let detailUrl = jsonR["url"].stringValue
                        let urlImage = jsonR["spacestation"]["image_url"].stringValue
                        let name = jsonR["name"].stringValue
                        let spacestation = jsonR["spacestation"]["name"].stringValue
                        let dataS = SpaceDataStruct(detailUrl:detailUrl, urlImage: urlImage, nameLabel: name, descrLabel: spacestation)
                        self.spaceDataArray.append(dataS)
                        self.spaceCollection.reloadData()
                        self.activityIndicator.stopAnimating()
                        
                    }
                }
                
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
