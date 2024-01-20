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
    
    func addSeparatorLine() {
        
        let line = UIView().then {
            $0.backgroundColor = grayColor
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "#%02x%02x%02x", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

extension String {
    func htmlText(hexString: String, font: UIFont) -> NSAttributedString {
        
        let style = "<span style=\"color: \(hexString); font-size: \(font.pointSize)px;\">%@</span>"
        let modified = String(format:"\(style)<p class=normal>%@</p>", self)
        do {
            guard let data = modified.data(using: .unicode) else {
                return NSAttributedString(string: self)
            }
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString(string: self)
        }
    }
}
