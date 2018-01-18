//
//  SuggestListViewController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 11/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit
import CoreData


enum ControllerState: String {
    case fromWeb, fromCoreData
    mutating func startWebFetching() {
        self = .fromWeb
    }
}

class SuggestListViewController: UIViewController {
    
    weak var rootControler:MainViewController?
    var pointT:EditingPointType = .departure
    let listContent = SugestList()
    var state: ControllerState = .fromCoreData
    
    lazy var coreData = PointCoreData("CorePoint")
    
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
        self.state.startWebFetching()
        listContent.fetch(keyword: textField.text! , source: true, view: self)
    }
    
}
    
    extension SuggestListViewController: UITableViewDataSource, UITableViewDelegate {
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch self.state {
            case .fromCoreData:
                switch coreData.count() {
                    case 0: return 1
                    default: return coreData.count()+1
                }
            case .fromWeb:
                switch listContent.count {
                case 0:
                    return 1
                default:
                    return listContent.count
                }
            }
        }
        
        public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var type:pointType? = nil
            let cell = tableView.dequeueReusableCell(withIdentifier: "PointCell") as! SuggestListViewCell
            switch self.state {
                case .fromCoreData:
                    let points = coreData.fetchData()
                    switch indexPath.row {
                    case 0: let cellHead =  tableView.dequeueReusableCell(withIdentifier: "SavePointsHead") as! SuggestHeadCell
                            cellHead.controller = self
                            return cellHead
                    default:
                            if indexPath.row-1 > points.count-1 {
                                let cellHead = UITableViewCell()
                                return cellHead
                            }
                            else {
                                cell.title.text = points[indexPath.row-1].getName()
                                cell.descrption.text = points[indexPath.row-1].getDesc()
                                type = points[indexPath.row-1].type
                                }
                            }
                case .fromWeb:
                    switch listContent.count {
                    case 0:
                        let cellHead =  tableView.dequeueReusableCell(withIdentifier: "NoMatch")!
                        return cellHead
                    default:
                        cell.title.text = listContent.title(row: indexPath)
                        cell.descrption.text = listContent.description(row: indexPath)
                        type = listContent.getType(row: indexPath)
                }
            }
            
            switch type {
                case .bigCity?: cell.image0.image = #imageLiteral(resourceName: "CIty.png")
                case .city?: cell.image0.image = #imageLiteral(resourceName: "BigCity.gif")
                case .street?: cell.image0.image = #imageLiteral(resourceName: "Street.gif")
                case .groupStop?: cell.image0.image = #imageLiteral(resourceName: "GroupStop.gif")
                case .busStop?: cell.image0.image = #imageLiteral(resourceName: "Busstop.gif")
                case .urbanStop?: cell.image0.image = #imageLiteral(resourceName: "UrbanStop.gif")
                case .railStop?: cell.image0.image = #imageLiteral(resourceName: "RailStop.gif")
                case .none: cell.image0.image = #imageLiteral(resourceName: "BigCity.gif")
            }
            
            tableView.rowHeight = 60
            return cell
    
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        public func reloadData() {
            tableView.reloadData()
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let rootController = rootControler else {return}
            var point:Point? = nil
            switch self.state {
            case .fromCoreData:
                switch indexPath.row {
                case 0: break
                default:  point = coreData.fetchData()[indexPath.row-1]
                }
            case .fromWeb:
                switch listContent.count {
                case 0: break
                default:  point = listContent.selectPointAt(index: indexPath)
                guard let point = point else {return}
                    coreData.addPoint(point)
                }}
                    
                if point != nil {
                
                        switch pointT {
                        case .arrival:
                            rootController.endField.textColor = UIColor.red
                            rootController.endField.text = point?.getName()
                            rootController.detailEndPoint.text = point?.getDesc()
                            rootController.task.defineEndPoint(point: point)
                        case .departure:
                            rootController.startField.textColor = UIColor.green
                            rootController.startField.text = point?.getName()
                            rootController.detailStartPoint.text = point?.getDesc()
                            rootController.task.defineStartPoint(point: point)
                        }
                }
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
        
            
            
    }


extension SuggestListViewController {
    
    enum saveErr:Error{
        case delegateError,entityError
        
        func type()->String {
            switch self{
            case .delegateError: return "DelegateError"
            case .entityError: return "entityError"
            }
            
        }
        
    }
    
    

    
    func cleanCoreData(){
        
        coreData.clearData("CorePoint")
            
        self.reloadData()
        
        
    }
    
}





