//
//  ViewController2.swift
//  NYTApp
//
//  Created by Виталий on 2/25/21.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit


class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var FavoriteCollectionView: UICollectionView!
    
    var detail: [DetailScreen]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        self.FavoriteCollectionView.dataSource = self
        self.FavoriteCollectionView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector (addButton(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        
        loadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData()
    }
    
    @objc func addButton(sender: UIButton){
        
        clearData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = detail?.count{
            return count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath)
            as! FavoriteCollectionViewCell
        
        if let details = detail?[indexPath.item] {
            cell.detail = details
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "favoriteShowDetail", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.FavoriteCollectionView?.indexPathsForSelectedItems?.first?.row {
          let name = detail?[indexPath].detail
            if let destination = segue.destination as? FavoriteDetails {
                destination.detail = name
            }
        }
    }
    
}


extension FavoriteViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 80)
        return size
    }
}



