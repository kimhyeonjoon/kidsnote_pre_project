//
//  SearchViewController.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import UIKit
import SnapKit
import Then

let blueColor = UIColor(135, 206, 235)
let grayColor = UIColor.lightGray

class SearchViewController: UIViewController {
    
    // header
    lazy var headerView = UIView()
    // back button
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: .normal)
    }
    // search textfield
    lazy var searchTextField = UITextField().then {
        $0.text = "아이폰"
        $0.textColor = .white
        $0.borderStyle = .none
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.clearButtonMode = .never
        
        $0.delegate = self
        
        $0.attributedPlaceholder = NSAttributedString(string: "Play 북에서 검색", attributes: [.foregroundColor : grayColor])
    }
    // clear button
    lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "close"), for: .normal)
        $0.addTarget(self, action: #selector(touchClear), for: .touchUpInside)
    }
    
    let headerHeight: CGFloat = 100
    
    
    // collection view
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case item(ItemModel)
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias CellProvider = DataSource.CellProvider
    
    private lazy var dataSource = makeDataSource()
    
    // collection view
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 20
        $0.minimumInteritemSpacing = 0
        
        $0.sectionInset = .zero
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: headerHeight)
        
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    }).then {
        
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        
        $0.register(SearchCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier)
        $0.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func setupLayout() {
        
        view.addSubview(headerView)
        headerView.addSubViews([backButton, searchTextField, clearButton])
        addUnderLine(headerView)
        
        // header
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        backButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview()
        }
        clearButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.leading.equalTo(searchTextField.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addUnderLine(_ view: UIView) {
        
        let line = UIView().then {
            $0.backgroundColor = grayColor
        }
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    @objc func touchClear() {
        searchTextField.text = ""
        clearButton.isHidden = true
    }
}


// Request
extension SearchViewController {
    
    func requestSearch() {
        
        guard let text = searchTextField.text else { return }
        guard text != "" else { return }
        
        self.applySnapShot(list: []) {
            self.collectionView.isHidden = false            
        }
        
        let str = Urls.search(keyword: text).path
        NetworkManager.shared.request(path: str) { (model: SearchListModel?) in
            if let model = model, let items = model.items {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.applySnapShot(list: items)
                })
            }
        } failure: { error in
            print(error)
        }
    }
}

// UICollectionView
extension SearchViewController: UICollectionViewDelegate {
    
    private func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
                
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as? SearchCollectionCell {
                
                switch item {
                case .item(let item):
                    cell.item = item
                }
                return cell
            }
            
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier, for: indexPath) as? SearchCollectionHeaderView else {
                return SearchCollectionHeaderView()
            }
            
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapShot(list: [ItemModel], completion: (() -> Void)? = nil) {
        
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        
        let items = list.map { Item.item($0) }
        snapShot.appendItems(items, toSection: .main)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, completion: completion)
        }
    }
}

// UITextField Delegate
extension SearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ noti: Notification) {
        collectionView.isHidden = true
        if let text = searchTextField.text {
            clearButton.isHidden = text.count < 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.count ?? 0 < 1 {
            return false
        }
        
        textField.resignFirstResponder()
        
        // search
        self.requestSearch()
        
        return true
    }
}
