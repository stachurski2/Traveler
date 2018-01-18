//
//  EndDetailCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 16/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class EndDetailCell: UITableViewCell {

    @IBOutlet weak var EndPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showEndPoint(indexPath: IndexPath, connection:Connection)->Void{
        let number  = indexPath.section
        EndPoint.text = connection.subConnections[number].end
        
        
        
        
    }

}
