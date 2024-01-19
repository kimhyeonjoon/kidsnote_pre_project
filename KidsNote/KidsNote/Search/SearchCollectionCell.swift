//
//  SearchCollectionCell.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionCell"
    
    var item: ItemModel? {
        didSet {
            updateUi()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .green
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
    }
    
    func updateUi() {
        
//        guard let item = self.item else { return }
//        print(item)
    }
}
