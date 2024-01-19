//
//  SearchCollectionHeaderView.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/18.
//

import UIKit
import SnapKit
import Then

enum TabType: Int {
    case eBook = 0
    case audioBook = 1
}

class SearchCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SearchCollectionHeaderView"
    
    // tab
    lazy var tabView = UIView()
    // eBook
    lazy var eBookButton = UIButton().then {
        
        $0.setTitle("eBook", for: .normal)
        $0.setTitleColor(blueColor, for: .selected)
        $0.setTitleColor(grayColor, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        $0.tag = TabType.eBook.rawValue
        $0.addTarget(self, action: #selector(touchTab(_:)), for: .touchUpInside)
    }
    // audio Book
    lazy var aBookButton = UIButton().then {
        
        $0.setTitle("오디오북", for: .normal)
        $0.setTitleColor(blueColor, for: .selected)
        $0.setTitleColor(grayColor, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        $0.tag = TabType.audioBook.rawValue
        $0.addTarget(self, action: #selector(touchTab(_:)), for: .touchUpInside)
    }
    // tab view under line
    lazy var tabUnderLine = UIView().then {
        $0.backgroundColor = blueColor
    }
    
    // separator
    lazy var separatorLine = UIView().then {
        $0.backgroundColor = grayColor
    }
    
    // title label
    lazy var titleLabel = UILabel().then {
        $0.text = "Google Play 검색결과"
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    var tabClosure: ((TabType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        pageInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        addSubViews([tabView, separatorLine, titleLabel])
        tabView.addSubViews([eBookButton, aBookButton, tabUnderLine])
        
        // tab
        tabView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        eBookButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(tabView.snp.centerX)
        }
        aBookButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(tabView.snp.centerX)
        }
        
        
        // separator
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        // titla label
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func pageInit() {
        
        eBookButton.isSelected = true
        eBookButton.titleLabel?.sizeToFit()
        
        tabUnderLine.snp.makeConstraints {
            $0.centerX.equalTo(eBookButton.snp.centerX)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: eBookButton.titleLabel?.bounds.width ?? 0, height: 2))
        }
    }
    
    @objc func touchTab(_ sender: UIButton) {
        
        guard let type = TabType(rawValue: sender.tag) else {
            return
        }
        print(type)
                
        eBookButton.isSelected = type == .eBook
        aBookButton.isSelected = type != .eBook
        
        let button = type == .eBook ? eBookButton : aBookButton
        
        tabUnderLine.snp.remakeConstraints {
            $0.centerX.equalTo(button.snp.centerX)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: button.titleLabel?.bounds.width ?? 0, height: 2))
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        tabClosure?(type)
    }
}
