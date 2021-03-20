//
//  ViewController1.swift
//  NYTApp
//
//  Created by Виталий on 2/25/21.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON

class MostEmailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let url = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key="
    
    private let apiKey = "20Pt17SvBGGVP3lQHtUtrR8ei7XLOwVI"

    
    var dataArray: [NYTDataStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getReqest()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailEmailed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MostEmailedDetails {
            destination.detailData = dataArray[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

}

extension MostEmailedViewController {
    
    private func getReqest(){
        
        Alamofire.request("\(url)\(apiKey)").responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(_):
                if let responseStr = response.result.value{
                    let jsonResponse = JSON(responseStr)
                    let jsonResults = jsonResponse["results"].array!
                    
                    self.dataArray.removeAll()
                    
                    for jsonR in jsonResults{
                        
                        let url = jsonR["url"].stringValue
                        let title = jsonR["title"].stringValue
                        let dataS = NYTDataStruct(url: url, title: title)
                        self.dataArray.append(dataS)
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
                
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
