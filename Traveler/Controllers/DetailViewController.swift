  //
//  DetailViewController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 26/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
   
    var subDetailInfo:[Int:Bool]=[:]
    var subStopsInfo:[Int:Bool]=[:]
    var state:ControllerState = .fromCoreData
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        guard let content = content else {return}
        if content.subConnections.count != 0 {
            for i in  1...content.subConnections.count {
                subDetailInfo.updateValue(false, forKey: i)
                subStopsInfo.updateValue(false, forKey: i)
            }
        }
        
        
        
        
        
    }
        var content:Connection?
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
            case .fromWeb: saveButton.isEnabled = true
            case .fromCoreData: saveButton.isEnabled = false
            
        }
        
    }
    
   
    

    @IBAction func closeView(_ sender: Any) {

        
        DispatchQueue.main.async() {
            self.navigationController?.popViewController(animated: true)
        }
        


    }
    
    @IBAction func saveConnection(_ sender: Any) {
        guard let connection = content else {return}
        connection.saveConnectionToCoreData()       
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setDetail(i:Int){
        guard let info = subDetailInfo[i+1] else {return }
        subDetailInfo[i+1] = !info
    }
    
   
    
    func checkDetailStatus(i:Int)->Bool{
        guard let result =  subDetailInfo[i+1] else {return false}
        return result
    }
    
    func setDetailStops(i:Int){
        guard let info = subStopsInfo[i+1] else {return }
        subStopsInfo[i+1] = !info
    }
    
    func checkStopsStatus(i:Int)->Bool{
        guard let result =  subStopsInfo[i+1] else {return false}
        
        
        return result
    }
    
    func getSubStopsNumber(i:Int)->Int {
        guard let content = content else {return 0}
        guard let stops = content.intermediateStops else {return 0}
        
        return stops[i].count
    }
    
    
    func getStopName(x:Int, y:Int)->String {
        guard let content = content else {return ""}

       
        return  content.getStopName(x:x, y:y)
    }
    
    func getStopTime(x:Int, y:Int)->String {
        guard let content = content else {return ""}
        
        
        return  content.getStopTime(x:x, y:y)
    }
    
    func getStopDate(x:Int, y:Int)->String {
        guard let content = content else {return ""}
        
        
        return  content.getStopDate(x:x, y:y)
    }
    
    
    
    
}

extension DetailViewController: UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let content = content else {return 0 }
        
        return content.subConnections.count
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let content = content else {return 0 }
        if section == content.subConnections.count - 1 {
            return 5 }
        else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let content = content else {return UITableViewCell() }
         switch indexPath.row {
            case 0:
                var cell = HintCell()
                cell =  tableView.dequeueReusableCell(withIdentifier: "HintCell") as! HintCell
                cell.showHint(connection: content, indexPath: indexPath)
                return cell
            case 1:
                var cell = StartDetailCell()
                cell =  tableView.dequeueReusableCell(withIdentifier: "StartCell") as! StartDetailCell
                cell.showStartPoint(indexPath: indexPath, connection:content)
                return cell
            case 2:
                var cell = InfoDetailCell()
                cell =   tableView.dequeueReusableCell(withIdentifier: "TypeCell") as! InfoDetailCell
                cell.showDetails(indexPath: indexPath, connection: content)
                cell.controller = self
                cell.indexPath = indexPath
                if self.checkDetailStatus(i: indexPath.section) { cell.showAdvice() }
                let status = self.checkStopsStatus(i: indexPath.section)
                if status {
                    cell.hideStops()
                    let stopNumbers = self.getSubStopsNumber(i:indexPath.section)
                    cell.stopHeight.constant = CGFloat(20*stopNumbers+10)
                    cell.viewStop.isHidden = false
                    cell.showStops(indexPath: indexPath)
                }
                else {
                    cell.hideStops()
                    cell.viewStop.isHidden = true
                }
                
                status==true ? cell.buttonStops.setTitle("Hide stops", for: .normal) : cell.buttonStops.setTitle("Show intermediate stops", for: .normal)
                
                return cell
            case 3:
                var cell = EndDetailCell()
                cell =   tableView.dequeueReusableCell(withIdentifier: "EndCell") as! EndDetailCell
                cell.showEndPoint(indexPath: indexPath, connection: content)
                return cell
         case 4:
                var cell = HintCell()
                cell =  tableView.dequeueReusableCell(withIdentifier: "HintCell") as! HintCell
                cell.showHint(connection: content, indexPath: indexPath)
                return cell
         default:
            let cell = UITableViewCell()
                return cell
            
            

            
        }
       
    }
    
    func reloadData()->Void {
        
        tableView.beginUpdates()
        tableView.endUpdates()
      
    }
    
    func reloadData(indexPath:IndexPath)->Void {
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
    
    
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            // HintCell()
            return 75
        case 1:
            // StartDetailCell()
            return 30
        case 2:
            // InfoDetailCell()
            if self.checkDetailStatus(i: indexPath.section) {
                if self.checkStopsStatus(i: indexPath.section){
                    let result = 120 + 20*self.getSubStopsNumber(i:indexPath.section)
                    return CGFloat(result)
                }
                else {
                return 105
                }
            }
            else {
                return 50
            }
        case 3:
            // EndDetailCell()
            return 30
        case 4:
           // HintCell()

             return 75
        default:
             return 0




    }

    }


}



