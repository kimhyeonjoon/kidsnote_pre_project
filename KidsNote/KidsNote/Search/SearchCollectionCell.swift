//
//  SearchCollectionCell.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionCell"
    
    // image
    lazy var imageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 2
    }
    
    // title
    lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.numberOfLines = 2
    }
    
    // author
    lazy var authorLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    // type
    lazy var typeLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    var item: ItemModel? {
        didSet {
            updateUi()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        addSubViews([imageView, titleLabel, authorLabel, typeLabel])
        
        // image
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(60)
        }
        
        // title
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // author
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // type
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func updateUi() {
        
        guard let item else {
            return
        }
        
        // image
        NetworkManager.shared.requestImage(path: item.volumeInfo?.imageLinks?.url() ?? "") { image in
            self.imageView.image = image
        } failure: { error in
            print(" failure image load")
            self.imageView.image = nil
        }
        
        // title
        titleLabel.text = item.titleText()
        
        // authors
        authorLabel.text = item.authosText()
        
        // type
        typeLabel.text = item.eBookAveText()
    }
}
