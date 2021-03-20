//
//  LoadData.swift
//  NYTApp
//
//  Created by Виталий on 19.03.2021.
//  Copyright © 2021 Виталий. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension FavoriteViewController{
    
    func loadData(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchReqest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailScreen")
            
            do{
                try detail = context.fetch(fetchReqest) as? [DetailScreen]
                
                self.FavoriteCollectionView.reloadData()
                
            }catch let err{
                print(err)
            }
        }
    }
    
    
    func clearData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do{
                let fetchRequestFriends: NSFetchRequest<MainScreen> = MainScreen.fetchRequest()
                
                let fetchFriend = try context.fetch(fetchRequestFriends)
                
                for friend in fetchFriend{
                    context.delete(friend)
                }
                
                let fetchRequest: NSFetchRequest<DetailScreen> = DetailScreen.fetchRequest()
                
                let fetchedMassage = try context.fetch(fetchRequest)
                
                for message in fetchedMassage{
                    context.delete(message)
                }
                
                try context.save()
                
                self.FavoriteCollectionView.reloadData()
                
            }catch let err{
                print(err)
            }
        }
        
        self.loadData()
        
    }
}
