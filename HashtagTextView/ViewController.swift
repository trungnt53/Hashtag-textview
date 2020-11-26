//
//  ViewController.swift
//  HashtagTextView
//
//  Created by Nguyen Tien Trung on 11/25/20.
//  Copyright © 2020 Nguyen Tien Trung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tagging: Tagging!
    var matchHashtag: [String] = [] {
        didSet {
            dropDownTBV.tableView.reloadData()
        }
    }
    var dropDownTBV: DropDownTBView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dropDownTBV == nil {
            dropDownTBV = DropDownTBView(belowView: tagging, size: tagging.frame.size)
            dropDownTBV.delegate = self
            dropDownTBV.dataSource = self
        }
    }

    private func setupView() {
        tagging.delegate = self
    }
    
    private func dumData(_ text: String) {
        if text.first == "a" {
            matchHashtag = ["aaa", "aab", "aac", "abc", "abcd", "addd"]
        }
        if text.first == "b" {
            matchHashtag = ["bbb", "bcd", "bad", "bee", "bad", "baaa"]
        }
        if text.first == "d" {
            matchHashtag = ["dba", "dcd", "ddd", "daaa", "ddddddd", "deccc"]
        }
        if text.first == "x" {
            matchHashtag = ["xyz", "xxx", "xad", "xwd", "xadf", "xxxxdafd"]
        }
    }
}

extension ViewController: TaggingDelegate {
    func taggingDidDetect(_ textSearch: String) {
        dumData(textSearch)
    }
    
    func taggingDidEndDetectSearch() {
        dropDownTBV.hide()
    }
}

extension ViewController: DropDownTBViewDelegate, DropDownTBViewDataSource {
    func dropDownView(_ dropDownView: DropDownTBView, didSelectRowAt indexPath: IndexPath) {
        let item = matchHashtag[indexPath.row]
        tagging.setHashtag(item)
    }
    
    func dropDownView(_ dropDownView: DropDownTBView, numberOfRowsInSection section: Int) -> Int {
        let count = matchHashtag.count
        if count > 0 {
            dropDownView.show()
        } else {
            dropDownView.hide()
        }
        return count
    }
    
    func dropDownView(_ dropDownView: DropDownTBView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropDownView.tableView.dequeueNibCell(DropDownTBVCell.self)
        cell.label.text = matchHashtag[indexPath.row]
        return cell
    }
}
