//
//  ResultViewTableCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 04/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class ResultViewTableCell: UITableViewCell {
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var changes: UILabel!
    
    
   
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var image5: UIImageView!
    
    @IBOutlet weak var image6: UIImageView!
    
    @IBOutlet weak var image7: UIImageView!
    
    
    
    
    func subConections(_ connection:Connection) -> Void {
        switch connection.numberOfChanges {
            case 1?:
                image1.isHidden = false
                image2.isHidden = true
                image3.isHidden = true
                image4.isHidden = true
                image5.isHidden = true
                image6.isHidden = true
                image7.isHidden = true
            case 2?:
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = true
                image4.isHidden = true
                image5.isHidden = true
                image6.isHidden = true
                image7.isHidden = true
            case 3?:
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = false
                image4.isHidden = true
                image5.isHidden = true
                image6.isHidden = true
                image7.isHidden = true
            case 4?:
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = false
                image4.isHidden = false
                image5.isHidden = true
                image6.isHidden = true
                image7.isHidden = true
            case 5?:
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = false
                image4.isHidden = false
                image5.isHidden = false
                image6.isHidden = true
                image7.isHidden = true
            case 6?:
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = false
                image4.isHidden = false
                image5.isHidden = false
                image6.isHidden = false
                image7.isHidden = true
            case .none, .some(_):
                image1.isHidden = false
                image2.isHidden = false
                image3.isHidden = false
                image4.isHidden = false
                image5.isHidden = false
                image6.isHidden = false
                image7.isHidden = false
        }
    }
        
        
    func setSubConnection(_ number:Int?, _ type:String?, _ changes:Int) -> Void {
            guard let number = number,
                  let type = type else {return}
            
                  var image = UIImage()
            
            if number <= 6 {
                switch type {
                    case "BUS": image = #imageLiteral(resourceName: "coach.gif")
                    case "TRAIN": image = #imageLiteral(resourceName: "train.gif")
                    case "URBAN_BUS": image = #imageLiteral(resourceName: "bus.gif")
                    case "URBAN_SUBWAY": image = #imageLiteral(resourceName: "train.gif")
                    case "AUT": image = #imageLiteral(resourceName: "coach.gif")
                    default:
                        print ("Another type:x \(type)")
                }
            }
            else {return}
        switch changes {
        case 0:
            image1.image = image
        case 1:
            switch number {
                    case 1: image1.image = image
                    default: image2.image = image
                    }
        case 2:
            switch number {
                case 1: image3.image = image
                case 2: image1.image = image
                default: image2.image = image
            }
        case 3:
            switch number {
                case 1: image4.image = image
                case 2: image3.image = image
                case 3: image1.image = image
                default: image2.image = image
            }
        case 4:
            switch number {
                case 1: image4.image = image
                case 2: image3.image = image
                case 3: image1.image = image
                case 4: image2.image = image
                default: image5.image = image
            }
        case 5:
            switch number {
                case 1: image6.image = image
                case 2: image4.image = image
                case 3: image3.image = image
                case 4: image1.image = image
                case 5: image2.image = image
                default: image5.image = image
            }
        default:
            switch number {
                case 1: image6.image = image
                case 2: image4.image = image
                case 3: image3.image = image
                case 4: image1.image = image
                case 5: image2.image = image
                case 6: image5.image = image
                default: image7.image = image
                }
    
//        switch number {
//        case 1:
//            image1.image = image
//        case 2:
//            image2.image = image
//        case 3:
//            image3.image = image
//        case 4:
//            image4.image = image
//        case 5:
//            image5.image = image
//        case 6:
//            image6.image = image
//        default:
//            break;
//        }
        }
        
        
        
        
        
        }
}
