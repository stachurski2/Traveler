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
    
    let aSubView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let label:UILabel =  UILabel(frame: CGRect(x:150, y:50, width:100, height:50))
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame:  CGRect(x:250, y:50, width:10, height:10))
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
      
        
        if content != nil {
            conections.huskFromHtmlString(htmlContent: content!)
            tableView.reloadData()
        }   
        
            
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideLoadingComunicate()

        super.viewWillAppear(animated)
        
        let barBtnVar = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = barBtnVar
        
      
        
    }
    

    
    @IBAction func back(_ sender: Any) {
       
        _ = self.navigationController?.popViewController(animated: true)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let content = sender as? Connection,
                let resultVC = segue.destination as? DetailViewController
                else { return }
            resultVC.state = .fromWeb
            resultVC.content = content
        }
            self.hideLoadingComunicate()
        
        
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
        cell.subConections(conections.connection(indexPath))
        tableView.rowHeight = 135
        
      
      
        for index in 0...changes {
            let subconnection = conections.connect[indexPath.row].getSubConnection(index)
             let type = subconnection.type 
            cell.setSubConnection(index+1,type,changes)
        }
        

        return cell
    }
    
    

    
    
   
    
    
    
    
}


extension ResultViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let content = conections.connection(indexPath)
        content.getDetail(self)
    
      
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

         return indexPath
    }
    

    
    
    
    
}



extension ResultViewController:loading {
    func showLoadingComunicate() {
        label.text = "Loading!"
        aSubView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        indicator.activityIndicatorViewStyle = .gray
        aSubView.backgroundColor = UIColor.yellow
        label.backgroundColor = UIColor.yellow
        indicator.startAnimating()
        aSubView.addSubview(label)
        aSubView.addSubview(indicator)
        super.view.addSubview(aSubView)
        view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: aSubView, attribute:  .centerY, relatedBy: .equal, toItem: self.view, attribute:.centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200))
        aSubView.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: aSubView, attribute: .top, multiplier: 1, constant: 40))
        aSubView.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: aSubView, attribute: .leading, multiplier: 1, constant: 65))
        aSubView.addConstraint(NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: aSubView, attribute: .top, multiplier: 1, constant: 40))
        aSubView.addConstraint(NSLayoutConstraint(item: indicator, attribute: .trailing, relatedBy: .equal, toItem: aSubView, attribute: .trailing, multiplier: 1, constant: -30))
    }
    
    func hideLoadingComunicate() {
        indicator.stopAnimating()
        aSubView.removeFromSuperview()
    }
    
    func showError(_ message:String) {
        let alert = UIAlertController(title: "Mistake", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}

