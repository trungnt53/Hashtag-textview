//
//  GSDropTBHashtagCell.swift
//  GolfSalon
//
//  Created by Trung, Nguyen Tien  on 11/13/20.
//  Copyright © 2020 NTQ Solution. All rights reserved.
//

import UIKit

class GSDropTBHashtagCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    weak var delegate: DropDownTBVCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setText(_ text: String) {
        label.text = text
    }
    
    @IBAction func cellTouch(_ sender: Any) {
        if let index = indexPath {
            delegate?.didTouchCell(indexPath: index)
        }
    }
}
