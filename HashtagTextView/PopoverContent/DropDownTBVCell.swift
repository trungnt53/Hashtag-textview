//
//  DropDownTBVCell.swift
//  GolfSalon
//
//  Created by Nguyen Tien Trung on 9/22/20.
//  Copyright © 2020 NTQ Solution. All rights reserved.
//

import UIKit

protocol DropDownTBVCellDelegate: NSObjectProtocol {
    func didTouchCell(indexPath: IndexPath)
}

class DropDownTBVCell: UITableViewCell {

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
