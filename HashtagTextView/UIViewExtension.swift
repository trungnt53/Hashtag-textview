//
//  UIViewExtension.swift
//  HashtagTextView
//
//  Created by Nguyen Tien Trung on 11/25/20.
//  Copyright © 2020 Nguyen Tien Trung. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeContraintToFullParent() {
        makeConstraint(inset: .zero)
    }
    
    func makeConstraint(inset: UIEdgeInsets) {
        guard let parrentView = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["view": self]
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(inset.left)@999)-[view]-(\(inset.right))-|", metrics: nil, views: dict))
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(inset.top)@999)-[view]-(\(inset.bottom))-|", metrics: nil, views: dict))
    }
    
    func makeConstraintSafeArea(inset: UIEdgeInsets = .zero) {
        guard let parrentView = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: parrentView.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parrentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: parrentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parrentView.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return .clear }
            return UIColor(cgColor: borderColor)
        }
        set {
            self.layer.borderColor = (newValue ?? UIColor.clear).cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UITableView {
    // MARK: - Cell
    func registerNibCell<C: UITableViewCell>(_ nibClass: C.Type) {
        let identifi = C.className
        self.register(UINib(nibName: identifi, bundle: nil), forCellReuseIdentifier: identifi)
    }
    
    func dequeueNibCell<C: UITableViewCell>(_ nibClass: C.Type, indexPath: IndexPath? = nil) -> C {
        let identifi = C.className
        if let index = indexPath {
            if let cell = self.dequeueReusableCell(withIdentifier: identifi, for: index) as? C {return cell}
        } else {
            if let cell = self.dequeueReusableCell(withIdentifier: identifi) as? C {return cell}
        }
        fatalError("It is NOT \(identifi), or NOT regisrer yet!")
    }
    
    // MARK: - HeaderFooter
    func registerNibHeaderFooter<H: UITableViewHeaderFooterView>(_ nibClass: H.Type) {
        let identifi = H.className
        self.register(UINib(nibName: identifi, bundle: nil), forHeaderFooterViewReuseIdentifier: identifi)
    }
    
    func dequeueNibHeaderFooter<H: UITableViewHeaderFooterView>(_ nibClass: H.Type) -> H {
        let identifi = H.className
        if let header = self.dequeueReusableHeaderFooterView(withIdentifier: identifi) as? H {return header}
        fatalError("It is NOT \(identifi), or NOT regisrer yet!")
    }
}

extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }
    
    public class var className: String {
        return String(describing: self)
    }
}
