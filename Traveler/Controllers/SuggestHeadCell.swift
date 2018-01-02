//
//  SuggestHeadCell.swift
//  
//
//  Created by Stanisaw Sobczyk on 18/11/2017.
//

import UIKit

class SuggestHeadCell: UITableViewCell {
    var controller: SuggestListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func cleanlist(_ sender: Any) {
        guard let controller = controller else {return}
                 controller.cleanCoreData()
        
        
    }
}
