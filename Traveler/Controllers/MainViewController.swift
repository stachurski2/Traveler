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
    var conections = [Connection]()
   
    
    //loadingBox
    let aSubView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let label:UILabel =  UILabel(frame: CGRect(x:150, y:50, width:100, height:50))
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame:  CGRect(x:250, y:50, width:10, height:10))
    
    //coreData
     lazy var coreData = CoreConnections("CoreConnection")

  
   
    
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var detailStartPoint: UILabel!
    @IBOutlet weak var detailEndPoint: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.text = task.showDate()
        timeTextField.text = task.showTime()
        startField.delegate = self
        endField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableview.dataSource = self
        tableview.delegate = self
//        tableview.allowsSelectionDuringEditing = true
 //       tableview.isEditing = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTextField.text = task.showDate()
        timeTextField.text = task.showTime()
        self.reloadData()
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
        
        if segue.identifier == "coreDetail" {
            guard let content = sender as? Connection,
                let resultVC = segue.destination as? DetailViewController
                else { return }
            resultVC.content = content
            resultVC.state = .fromCoreData
            print("Stops: \(content.intermediateStops!.count)")

        }
        
    }
    
   
    
    

    
}



extension MainViewController:loading {
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

extension MainViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connect") as! ConnectionTableCell
        
            guard let start = conections[indexPath.row].start, let end = conections[indexPath.row].end, let changes = conections[indexPath.row].numberOfChanges, let date = conections[indexPath.row].startDate else {return cell}
            
           

        
            cell.from.text = start
            cell.to.text = end
            switch changes{
                case 1: cell.changes.text = "Direct Connection"
                cell.changes.textColor = UIColor.red
                cell.changes.font = cell.changes.font.withSize(10)
                default:    cell.changes.text = "Changes: \(changes)"
                cell.changes.textColor = UIColor.black
                 cell.changes.font = cell.changes.font.withSize(14)
            }
            cell.date.text = date
            
        
   
        return cell
    }
    
    
    func reloadData() ->Void {
        coreData = CoreConnections("CoreConnection")
        conections = coreData.fetchData()
        tableview.reloadData()
        
        
    }
    

    
    
    
}


extension MainViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "coreDetail", sender: conections[indexPath.row])
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            print("Delete at \(indexPath.row)")
            self.coreData.deleteConnection(indexNumber: indexPath.row)
            self.reloadData()
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}





        

    
    
    




