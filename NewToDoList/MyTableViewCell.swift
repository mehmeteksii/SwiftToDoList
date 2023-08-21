//
//  MyTableViewCell.swift
//  NewToDoList
//
//  Created by Mehmet Ekşi on 18.08.2023.
//

import UIKit

class MyTableViewCell: BaseTableViewCell {

    @IBOutlet weak private var containerView :UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
        // Initialization code
    }
    
}
