//
//  MostEmailedDetails.swift
//  NYTApp
//
//  Created by Виталий on 2/25/21.
//  Copyright © 2021 Виталий. All rights reserved.
//

import UIKit
import WebKit


class MostEmailedDetails: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var detailData: NYTDataStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
                
        loadReqest()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        activityIndicator.stopAnimating()
    }
    
    func loadReqest(){
        
        let url = (detailData?.url)!
        let urlReqest = URLRequest(url: URL(string: url)!)
        webView.load(urlReqest)
        
    }

}
