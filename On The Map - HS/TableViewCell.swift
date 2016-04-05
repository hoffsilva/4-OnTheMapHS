//
//  TableViewCell.swift
//  On The Map - HS
//
//  Created by Hoff Henry Pereira da Silva on 28/12/15.
//  Copyright © 2015 hoff silva. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var labelMediaURL: UILabel!
    @IBOutlet weak var labelNameStudent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
