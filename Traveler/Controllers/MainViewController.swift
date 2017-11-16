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


class MainViewController: UIViewController, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var lookingStatus:EditingPointType = .departure
    var start:Choose = .empty
    var end:Choose = .empty
    let task = Task.sharedInstance
    
    
   
    
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var detailStartPoint: UILabel!
    @IBOutlet weak var detailEndPoint: UILabel!
    
   
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTextField.text = task.showDate()
        timeTextField.text = task.showTime()
    }


    @IBAction func startTextFieldEditing(_ sender: UITextField) {
         lookingStatus = .departure
        performSegue(withIdentifier: "select", sender: lookingStatus)
    }
    
    @IBAction func endTextFieldEditing(_ sender: UITextField) {
        lookingStatus = .arrival
        performSegue(withIdentifier: "select", sender: lookingStatus)
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
    
    @IBAction func changeTime(_ sender: Any) {
        performSegue(withIdentifier: "date", sender: task)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            guard let htmlContent = sender as? String,
                let resultVC = segue.destination as? ResultViewController
                else { return }
            resultVC.content = htmlContent
        }
        else if segue.identifier == "select" {
            
            guard let resultVC = segue.destination as? SuggestListViewController,
                let type = sender as? EditingPointType
                else { return }
            resultVC.pointT = type
            resultVC.rootControler = self
        }
        else if segue.identifier == "date" {
            
            guard let resultVC = segue.destination as? DateSelectController,
                let task = sender as? Task
                else {return}
            resultVC.task = task
        }
    }
    
    // loading box
    
    let aSubView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let label:UILabel =  UILabel(frame: CGRect(x:150, y:50, width:100, height:50))
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame:  CGRect(x:250, y:50, width:10, height:10))
    
    
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
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
    }
    

    
}









        

    
    
    




