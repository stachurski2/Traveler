//
//  InfoDetailCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 16/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//




import UIKit

class InfoDetailCell: UITableViewCell {

    var labels:[UILabel] = []
    var controller:DetailViewController?
    var indexPath:IndexPath?
    var advice:String = ""
    var subview:UIView = UIView(frame: CGRect(x: 10, y: 105, width: 300, height: 20))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var adviceText: UILabel!
    
    @IBOutlet weak var viewStop: UIView!
    
    @IBOutlet weak var stopHeight: NSLayoutConstraint!
    
    func showDetails(indexPath: IndexPath, connection: Connection) {
         let number  = indexPath.section
         let subConnection = connection.subConnections[number]
         switch subConnection.type {
            case "BUS": typeImage.image = #imageLiteral(resourceName: "coach.gif")
            case "TRAIN": typeImage.image = #imageLiteral(resourceName: "train.gif")
            case "URBAN_BUS": typeImage.image = #imageLiteral(resourceName: "bus.gif")
            case "URBAN_SUBWAY": typeImage.image = #imageLiteral(resourceName: "train.gif")
            case "AUT": typeImage.image = #imageLiteral(resourceName: "coach.gif")
            default: break
         }
        departure.text = "\(subConnection.startTime) \(subConnection.startDate)"
        arrival.text = "\(subConnection.endTime) \(subConnection.endDate)"
        kind.text = subConnection.kind
        companyName.text = subConnection.company
        guard let hints = connection.hints else {return}
        let number0 = (number+1)*2
        guard let text = hints[number0] else {return}
        advice = text
        
        
      
        
        
        
            
        
        
    }
    @IBAction func detailExtend(_ sender: Any) {
        guard let controller = controller,
              let indexPath = indexPath  else {return}
        
                controller.setDetail(i: indexPath.section)
           
                controller.reloadData(indexPath: indexPath)
        
    }
    
    @IBAction func showInterMediateStop(_ sender: Any) {
        
        guard let controller = controller,
            let indexPath = indexPath else {return}
        
        controller.setDetailStops(i: indexPath.section)
        
        
        
        controller.reloadData(indexPath: indexPath)
        
        
    }
    
    
    func showAdvice()->Void {
        self.adviceText.text = advice
        self.adviceText.isHidden = false
    }
    
    func showStops(indexPath:IndexPath)->Void{
            guard let controller = controller else {return}
            let stopNumbers = controller.getSubStopsNumber(i:indexPath.section)
        
       
        
            var controlDate =  controller.getStopDate(x: indexPath.section, y: 0)
        
            for i in 0..<stopNumbers {
                
                let label = UILabel(frame: CGRect(x: Int(viewStop.bounds.width*0.02), y: 10+i*20, width: Int(viewStop.bounds.width*0.65), height: 15))
                label.text =  controller.getStopName(x: indexPath.section, y: i)
                label.font = UIFont(name: "Arial", size: 14)
                self.viewStop.addSubview(label)
                 let label0 = UILabel(frame: CGRect(x: Int(viewStop.bounds.width*0.69), y: 10+i*20, width: Int(viewStop.bounds.width*0.12), height: 15))
                label0.text =  controller.getStopTime(x: indexPath.section, y: i)
                label0.font = UIFont(name: "Arial", size: 14)
                  self.viewStop.addSubview(label0)
                
                let label1 = UILabel(frame: CGRect(x: Int(viewStop.bounds.width*0.83), y:10+i*20, width: Int(viewStop.bounds.width*0.15), height: 15))
                
                switch i {
                    case 0:  label1.text = controller.getStopDate(x: indexPath.section, y: i)
                    case stopNumbers-1: label1.text = controller.getStopDate(x: indexPath.section, y: i)
                    default:
                        if controlDate == controller.getStopDate(x: indexPath.section, y: i) {
                            label1.text = ""
                        }
                        else {
                            label1.text = controller.getStopDate(x: indexPath.section, y: i)
                        }
                        controlDate = controller.getStopDate(x: indexPath.section, y: i)
                    }
                label1.font = UIFont(name: "Arial", size: 14)
                   self.viewStop.addSubview(label1)
                }
        
        

        
         viewStop.isHidden = false
         labels.removeAll()
        
     }
        
    
        
    
    
    func hideStops()->Void {
        for view in viewStop.subviews {
            view.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var buttonStops: UIButton!

    
    
    
    
    
    
    
}
