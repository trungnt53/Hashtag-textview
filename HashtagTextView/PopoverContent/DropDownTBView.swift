//
//  DropDownTBView.swift
//  AnimationMaker
//
//  Created by Mac-NS1-TienTrung on 03/09/2020.
//  Copyright © 2020 Trung Nguyen. All rights reserved.
//

import UIKit

typealias EmptyBlock = () -> Void
typealias Block<T> = (T) -> Void

protocol DropDownTBViewDelegate: class {
    func dropDownView(_ dropDownView: DropDownTBView, didSelectRowAt indexPath: IndexPath)
}

protocol DropDownTBViewDataSource: class {
    func dropDownView(_ dropDownView: DropDownTBView, numberOfRowsInSection section: Int) -> Int
    func dropDownView(_ dropDownView: DropDownTBView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class DropDownTBView: UIView {
    
    private var isShow = false
    var tableView: UITableView!
    weak var delegate: DropDownTBViewDelegate?
    weak var dataSource: DropDownTBViewDataSource?
    
    weak var belowView: UIView?
    var mSize = CGSize.zero
    init(belowView: UIView, size: CGSize) {
        super.init(frame: CGRect(x: belowView.frame.origin.x + belowView.frame.width/2 - size.width/2,
                                 y: belowView.frame.origin.y + belowView.frame.height + 5,
                                 width: size.width,
                                 height: size.height))
        belowView.superview?.addSubview(self)
        self.belowView = belowView
        self.mSize = size
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        clipsToBounds = true
        tableView = UITableView(frame: bounds)
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.cornerRadius = 6
        tableView.borderWidth = 1
        tableView.borderColor = .systemGray4
        tableView.registerNibCell(DropDownTBVCell.self)
        tableView.registerNibCell(GSDropTBHashtagCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.center = CGPoint(x: self.tableView.frame.width/2, y: -self.tableView.frame.height/2)
        isHidden = true
    }
    
    func updateFrame() {
        frame = CGRect(x: belowView!.frame.origin.x + belowView!.frame.width/2 - mSize.width/2,
                                 y: belowView!.frame.origin.y + belowView!.frame.height + 5,
                                 width: mSize.width,
                                 height: mSize.height)
    }
    
    func show() {
        if isShow == true {
            return
        }
        isShow = true
        isHidden = false
        tableView.reloadData()
        tableView.center = CGPoint(x: tableView.frame.width/2, y: -tableView.frame.height/2)
        tableView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.tableView.center = CGPoint(x: self.tableView.frame.width/2, y: self.tableView.frame.height/2)
        }
    }
    
    func hide(_ complete: EmptyBlock? = nil) {
        if isShow == false {
            return
        }
        isShow = false
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.center = CGPoint(x: self.tableView.frame.width/2, y: -self.tableView.frame.height/2)
        }) { _ in
            self.isHidden = true
            self.tableView.isHidden = true
            complete?()
        }
    }
}

extension DropDownTBView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.dropDownView(self, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource?.dropDownView(self, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDownView(self, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension DropDownTBView: DropDownTBVCellDelegate {
    func didTouchCell(indexPath: IndexPath) {
        delegate?.dropDownView(self, didSelectRowAt: indexPath)
    }
}
