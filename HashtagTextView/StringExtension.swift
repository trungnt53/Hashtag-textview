//
//  StringExtension.swift
//  HashtagTextView
//
//  Created by Nguyen Tien Trung on 11/25/20.
//  Copyright © 2020 Nguyen Tien Trung. All rights reserved.
//

import Foundation

extension String {
    var containsSpecialCharacter: Bool {
       let regex = ".*[^A-Za-z0-9\\p{Hangul}].*"
       let testString = NSPredicate(format:"SELF MATCHES %@", regex)
       return testString.evaluate(with: self)
    }
}
