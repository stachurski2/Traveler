//
//  ResultViewController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 16/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    var content:String?
    let webView = UIWebView()
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
     override func viewDidLoad() {
        super.viewDidLoad()
      
            
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
       
       
        let barBtnVar = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = barBtnVar
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin ,multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 0))
       
        if content != nil {
            webView.loadHTMLString(content!, baseURL: nil)
            
        }
        
    }
    

    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        print("back")
    }
    

}
