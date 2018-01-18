//
//  HintCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 16/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class HintCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var hintText: UILabel!
    
    
    func showHint(connection:Connection, indexPath:IndexPath)->Void{
        let number = connection.subConnections.count - 1
        switch indexPath.section {
            case number:
                switch indexPath.row {
                    case 0:
                        let number0 = (number+1)*2 - 1
                        hintText.text = connection.hints?[number0]
                    default:
                        let number0 = (number+1)*2 + 1
                        hintText.text = connection.hints?[number0]
                }
            
            default:
                let number0 = (indexPath.section + 1)*2 - 1
                        hintText.text = connection.hints?[number0]
            
            
            
            
            
            
            
        }
        
        
        
    }
    
}
