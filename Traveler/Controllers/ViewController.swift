//
//  ViewController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 29/09/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit
import WebKit

enum Choose {
    case empty, tapEditing, accepted
    
    mutating func startEdit() {
        self = .tapEditing
    }
    
    mutating func acceptChoose() {
        self = .accepted
    }
    
    mutating func declinceChoose() {
        self = .tapEditing
    }
}


enum EditingPointType {
    case arrival, departure
}


class MainViewController: UIViewController {
 
    var lookingStatus:EditingPointType = .departure
    var start:Choose = .empty
    var end:Choose = .empty
    
    let task = Task.sharedInstance
    let listContent = SugestList()
    
    let aSubView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let label:UILabel =  UILabel(frame: CGRect(x:150, y:50, width:100, height:50))
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame:  CGRect(x:250, y:50, width:10, height:10))
    
    
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var detailStartPoint: UILabel!
    @IBOutlet weak var detailEndPoint: UILabel!
    
   
    @IBOutlet weak var tableView: UITableView!
    let identifier = "PointCell"
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        dateTextField.text = task.showDate()
        timeTextField.text = task.showTime()
        startField.delegate = self
        endField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func startTextFieldEditing(_ sender: UITextField) {
        lookingStatus = .departure
        listContent.fetch(keyword: startField.text! , source: true, view: self)
        
        
    }
    
    @IBAction func endTextFieldEditing(_ sender: UITextField) {
        lookingStatus = .arrival
        listContent.fetch(keyword: endField.text! , source: true, view: self)
    

    }
    
    @IBAction func startDecline(_ sender: Any) {
        start = .tapEditing
        task.deleteStartPoint()
        detailStartPoint.text = ""
        startField.isUserInteractionEnabled = true
        startField.textColor = UIColor.black
        startField.text = ""
    }
    
    @IBAction func endDecline(_ sender: Any) {
        end = .tapEditing
        task.deleteEndPoint()
        detailEndPoint.text = "" 
        endField.isUserInteractionEnabled = true
        endField.textColor = UIColor.black
        endField.text = ""
    
    }
    


    
    @IBAction func directConnectionChanged(_ sender: UISwitch) {
        defer {print(task.directConnectionPrefer()) }
        task.changeDirectConnection(value: sender.isOn)
        
    }
    
    
    @IBAction func searchConnection(_ sender: UIButton) {
        task.start(viewController:self)
     
                    
    }
    
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContent.count
    }
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PointCell") as! SuggestListViewCell
        cell.title.text = listContent.title(row: indexPath)
        cell.descrption.text = listContent.description(row: indexPath)
        tableView.rowHeight = 100
        return cell
        
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         view.endEditing(true)
        switch lookingStatus {
        case .arrival:
            endField.isUserInteractionEnabled = false
            endField.textColor = UIColor.red
            endField.text = listContent.title(row: indexPath)
            detailEndPoint.text = listContent.description(row: indexPath)
            task.defineEndPoint(point: listContent.selectPointAt(index: indexPath))
            end = .accepted
         
            
        case .departure:
            startField.isUserInteractionEnabled = false
            startField.textColor = UIColor.green
            startField.text = listContent.title(row: indexPath)
            detailStartPoint.text = listContent.description(row: indexPath)
            task.defineStartPoint(point: listContent.selectPointAt(index: indexPath))
            start = .accepted
            
        }
    }
    

    
}

extension MainViewController {
    
    @IBAction func dateChanged(_ sender: UIStepper) {
        task.changeDate(stepper: sender.value)
        dateTextField.text = task.showDate()
    }
    @IBAction func timeChange(_ sender: UIStepper) {

         task.changeTime(stepper: sender.value)
        timeTextField.text = task.showTime()
    }
    
    
}


extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            guard let htmlContent = sender as? String,
                let resultVC = segue.destination as? ResultViewController
                else { return }
                 resultVC.content = htmlContent
            
        }
    }
    
    
}


extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension MainViewController {
    func showLoadComunicate()->Void {
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
        view.addSubview(aSubView)
        
            view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: aSubView, attribute:  .centerY, relatedBy: .equal, toItem: self.view, attribute:.centerY, multiplier: 1, constant: 0))
             view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100))
              view.addConstraint(NSLayoutConstraint(item: aSubView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200))
        
            aSubView.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: aSubView, attribute: .top, multiplier: 1, constant: 40))
            aSubView.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: aSubView, attribute: .leading, multiplier: 1, constant: 65))
        
        
            aSubView.addConstraint(NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: aSubView, attribute: .top, multiplier: 1, constant: 40))
            aSubView.addConstraint(NSLayoutConstraint(item: indicator, attribute: .trailing, relatedBy: .equal, toItem: aSubView, attribute: .trailing, multiplier: 1, constant: -30))
        
    
        
        }

    
    func hideLoadComunicate()->Void {
        indicator.stopAnimating()
        aSubView.removeFromSuperview()
        
    }
    
    
    
        }
        

    
    
    




