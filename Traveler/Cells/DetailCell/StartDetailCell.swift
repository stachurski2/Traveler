//
//  StartDetailCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 16/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class StartDetailCell: UITableViewCell {

    @IBOutlet weak var startPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showStartPoint(indexPath: IndexPath, connection:Connection)->Void{
        let number  = indexPath.section
        startPoint.text = connection.subConnections[number].start
    
        
        
        
    }

}
