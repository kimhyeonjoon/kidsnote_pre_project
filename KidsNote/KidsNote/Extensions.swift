//
//  Extensions.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/18.
//

import UIKit


extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
