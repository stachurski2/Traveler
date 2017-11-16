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
    var conections:Connections = Connections()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
            
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let barBtnVar = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = barBtnVar
        

        if content != nil {
            conections.huskFromHtmlString(htmlContent: content!)
            tableView.reloadData()
        }
        
    }
    

    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
      
    }
    

}


extension ResultViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conections.conectionCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultViewTableCell
        cell.start.text = conections.startPoint(indexPath)
        cell.end.text = conections.endPoint(indexPath)
        cell.startTime.text = conections.startTime(indexPath)
        cell.endTime.text = conections.endTime(indexPath)
        cell.startDate.text = conections.startDate(indexPath)
        cell.endDate.text = conections.endDate(indexPath)
        cell.travelTime.text = "Time travel \(conections.travelTime(indexPath))"
        let changes = conections.changes(indexPath)
        if changes == 0 { cell.changes.text = "Direct Connection"; cell.changes.textColor = UIColor.red }
        else {cell.changes.text = "Changes: \(changes)"}
        
        
        
        
        
         tableView.rowHeight = 120
        return cell
    }
    
    
}

