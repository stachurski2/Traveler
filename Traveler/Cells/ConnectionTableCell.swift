//
//  ConnectionTableCell.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 08/01/2018.
//  Copyright © 2018 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class ConnectionTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var changes: UILabel!
}
