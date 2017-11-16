//
//  SuggestListViewController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 11/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class SuggestListViewController: UIViewController {
    
    var rootControler:MainViewController?
    var pointT:EditingPointType = .departure
    let listContent = SugestList()
    
    
    @IBOutlet weak var pointType: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch pointT {
            case .departure: pointType.text = "Start"
            case .arrival: pointType.text = "End"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

        
    @IBAction func closeAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldEditing(_ sender: Any) {
        listContent.fetch(keyword: textField.text! , source: true, view: self)
    }
    
}
    
    extension SuggestListViewController: UITableViewDataSource, UITableViewDelegate {
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch listContent.count {
            case 0:
                return 1
            default:
                return listContent.count
            }
        }
        
        public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch listContent.count {
            case 0:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "NoMatch")!
                return cell
            default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PointCell") as! SuggestListViewCell
             cell.title.text = listContent.title(row: indexPath)
             cell.descrption.text = listContent.description(row: indexPath)
            let type = listContent.getType(row: indexPath)
            switch type {
                case .bigCity: cell.image0.image = #imageLiteral(resourceName: "CIty.png")
                case .city: cell.image0.image = #imageLiteral(resourceName: "BigCity.gif")
                case .street: cell.image0.image = #imageLiteral(resourceName: "Street.gif")
                case .groupStop: cell.image0.image = #imageLiteral(resourceName: "GroupStop.gif")
                case .busStop: cell.image0.image = #imageLiteral(resourceName: "Busstop.gif")
                case .urbanStop: cell.image0.image = #imageLiteral(resourceName: "UrbanStop.gif")
                case .railStop: cell.image0.image = #imageLiteral(resourceName: "RailStop.gif")
            }
             tableView.rowHeight = 60
            return cell
            }
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        public func reloadData() {
            tableView.reloadData()
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                // view.endEditing(true)
            switch listContent.count {
                case 0: break
                default:
                guard let rootController = rootControler else {return}
                switch pointT {
                case .arrival:
                      rootController.endField.isUserInteractionEnabled = false
                      rootController.endField.textColor = UIColor.red
                      rootController.endField.text = listContent.title(row: indexPath)
                      rootController.detailEndPoint.text = listContent.description(row: indexPath)
                      rootController.task.defineEndPoint(point: listContent.selectPointAt(index: indexPath))
                      rootController.end = .accepted
                case .departure:
                     rootController.startField.isUserInteractionEnabled = false
                     rootController.startField.textColor = UIColor.green
                     rootController.startField.text = listContent.title(row: indexPath)
                     rootController.detailStartPoint.text = listContent.description(row: indexPath)
                     rootController.task.defineStartPoint(point: listContent.selectPointAt(index: indexPath))
                     rootController.start = .accepted
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
    }
}


