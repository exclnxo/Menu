//
//  MenuDetailTableViewCell.swift
//  productMenu
//
//  Created by 徐常璿 on 2016/8/16.
//  Copyright © 2016年 Eric Hsu. All rights reserved.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
