//
//  GSTagging.swift
//  GSTagging
//
//  Created by Trung, Nguyen Tien  on 11/11/20.
//  Copyright © 2020 Trung, Nguyen Tien . All rights reserved.
//

import Foundation
import UIKit

protocol TaggingDelegate: NSObjectProtocol {
    func taggingDidDetect(_ textSearch: String)
    func taggingDidEndDetectSearch()
    func beginEditting(_ tagging: Tagging)
    func endEditting(_ tagging: Tagging)
    func tagging(_ tagging: Tagging, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func taggingDidChange(_ tagging: Tagging)
}

extension TaggingDelegate {
    func beginEditting(_ tagging: Tagging) { return }
    func endEditting(_ tagging: Tagging) { return }
    func tagging(_ tagging: Tagging, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { return true}
    func taggingDidChange(_ tagging: Tagging) { return }
}

class Tagging: UIView {
    var textView: UITextView?
    var symboi = "#"
    var hashTagsColor: UIColor = .blue
    weak var delegate: TaggingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        if textView == nil {
            textView = UITextView()
            addSubview(textView!)
            textView?.makeContraintToFullParent()
            textView?.delegate = self
            textView?.textColor = .black
            textView?.font = .systemFont(ofSize: 13)
        }
    }
    
    private func compare(_ text: String) -> Bool {
        return text == symboi
    }
    
    private func isInTagging(textView: UITextView) -> UITextPosition? {
        guard let currentCursorRange = textView.selectedTextRange else {
            return nil
        }
        if currentCursorRange.start != currentCursorRange.end {
            return nil
        }
        
        var detectPositionEnd: UITextPosition? = currentCursorRange.start
        var detectPositionStart: UITextPosition? = textView.position(from: detectPositionEnd!, offset: -1)
        while detectPositionStart != nil {
            let detectRange = textView.textRange(from: detectPositionStart!, to: detectPositionEnd!)
            let text = textView.text(in: detectRange!)
            if text!.containsSpecialCharacter, compare(text!) == false {
                return nil
            }
            detectPositionEnd = textView.position(from: detectPositionEnd!, offset: -1)!
            detectPositionStart = textView.position(from: detectPositionStart!, offset: -1)
            if detectPositionStart == nil {
                if compare(text!) == true {
                    return textView.beginningOfDocument
                }
                return nil
            }
            let endRange = textView.textRange(from: detectPositionStart!, to: detectPositionEnd!)
            if textView.text(in: endRange!)!.containsSpecialCharacter, compare(textView.text(in: endRange!)!) == false {
                if compare(text!) == true {
                    return detectPositionEnd
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    
    private func detectTextSearch(textView: UITextView) -> String? {
        guard let start = isInTagging(textView: textView) else {
            return nil
        }
        guard let range = textView.textRange(from: start, to: textView.selectedTextRange!.start) else {
            return nil
        }
        guard let text = textView.text(in: range) else {
            return nil
        }
        if String(text.dropFirst()).containsSpecialCharacter {
            return nil
        }
        return String(text.dropFirst())
    }
    
    private func textFor(textView: UITextView, position: UITextPosition, offSet: Int) -> String? {
        var range: UITextRange?
        if offSet < 0 {
            if let start = textView.position(from: position, offset: offSet) {
                range = textView.textRange(from: start, to: position)
            }
        } else {
            if let end = textView.position(from: position, offset: offSet) {
                range = textView.textRange(from: position, to: end)
            }
        }
        if let tempRange = range {
            return textView.text(in: tempRange)
        }
        return nil
    }
    
    private func detectHashtag(textView: UITextView) -> [UITextRange] {
        var allRange: [UITextRange] = []
        var detectTaget = textView.endOfDocument
        var detectPositionEnd: UITextPosition? = textView.endOfDocument
        var detectPositionStart: UITextPosition? = textView.position(from: detectPositionEnd!, offset: -1)
        while detectPositionStart != nil {
            let detectRange = textView.textRange(from: detectPositionStart!, to: detectPositionEnd!)
            let text = textView.text(in: detectRange!)
            if text!.containsSpecialCharacter, compare(text!) == false {
                detectTaget = textView.position(from: detectPositionEnd!, offset: -1)!
                detectPositionStart = textView.position(from: detectPositionEnd!, offset: -2)
                detectPositionEnd = textView.position(from: detectPositionEnd!, offset: -1)
                continue
            }
            detectPositionEnd = textView.position(from: detectPositionEnd!, offset: -1)!
            detectPositionStart = textView.position(from: detectPositionStart!, offset: -1)
            if detectPositionStart == nil {
                if compare(text!) == true {
                    allRange.append(textView.textRange(from: textView.beginningOfDocument, to: detectTaget)!)
                }
                return allRange
            }
            let endRange = textView.textRange(from: detectPositionStart!, to: detectPositionEnd!)
            if textView.text(in: endRange!)!.containsSpecialCharacter, compare(textView.text(in: endRange!)!) == false {
                if compare(text!) == true {
                    allRange.append(textView.textRange(from: detectPositionEnd!, to: detectTaget)!)
                }
                detectTaget = textView.position(from: detectPositionEnd!, offset: -1)!
            }
        }
        return allRange
    }
    
    private func selectionDidChange(_ textView: UITextView) {
        if let text = detectTextSearch(textView: textView), !text.isEmpty {
            delegate?.taggingDidDetect(text)
        } else {
            delegate?.taggingDidEndDetectSearch()
        }
    }
    
    private func changeTextColor() {
        let currentCursor = textView?.selectedTextRange
        let mutableAttributedString = NSMutableAttributedString.init(string: textView?.text ?? "")
        for range in detectHashtag(textView: textView!) {
            let text = String(textView!.text(in: range)!.dropFirst())
            if let nsRange = range.convertToNSRange(textView!), !text.containsSpecialCharacter, !text.isEmpty {
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: hashTagsColor, range: nsRange)
            }
        }
        textView?.attributedText = mutableAttributedString
        textView?.selectedTextRange = currentCursor
    }
    
    public func getHashtags() -> [String] {
        var hashtags: [String] = []
        for range in detectHashtag(textView: textView!) {
            let text = String(textView!.text(in: range)!.dropFirst())
            if !text.containsSpecialCharacter, !text.isEmpty {
                hashtags.append(text)
            }
        }
        return hashtags
    }
    
    public func setHashtag(_ hashtagString: String) {
        guard let start = isInTagging(textView: textView!), let end = textView?.selectedTextRange?.end else {
            return
        }
        guard let range = textView?.textRange(from: start, to: end) else {
            return
        }
        textView?.replace(range, withText: symboi + hashtagString + " ")
        changeTextColor()
    }
}

extension Tagging: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changeTextColor()
        delegate?.taggingDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.tagging(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        selectionDidChange(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.beginEditting(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.endEditting(self)
    }
}

extension UITextRange {
    func convertToNSRange(_ textInput: UITextInput) -> NSRange? {
        let location = textInput.offset(from: textInput.beginningOfDocument, to: start)
        let length = textInput.offset(from: start, to: end)
        return NSRange(location: location, length: length)
    }
}
