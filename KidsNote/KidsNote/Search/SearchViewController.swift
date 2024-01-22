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
let grayColor = UIColor(170, 170, 170)

class SearchViewController: UIViewController {
    
    // header
    lazy var headerView = UIView().then {
        $0.addSeparatorLine()
    }
    // back button
    lazy var backButton = UIButton().then {
        $0.setTitle("<", for: .normal)
        $0.setTitleColor(grayColor, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    // search textfield
    lazy var searchTextField = UITextField().then {
        $0.text = ""
        $0.textColor = .white
        $0.borderStyle = .none
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.clearButtonMode = .never
        
        $0.delegate = self
        
        $0.attributedPlaceholder = NSAttributedString(string: "Play 북에서 검색", attributes: [.foregroundColor : grayColor])
    }
    // clear button
    lazy var clearButton = UIButton().then {
        $0.setTitle("X", for: .normal)
        $0.isHidden = true
        $0.setTitleColor(grayColor, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.addTarget(self, action: #selector(touchClear), for: .touchUpInside)
    }
    
    
    // collection view
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ItemModel>
    private typealias CellProvider = DataSource.CellProvider
    
    private lazy var dataSource = makeDataSource()
    
    // collection view
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
        
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }).then {
        
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        
        $0.register(SearchCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier)
        $0.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
    }
    
    // refresh control
    lazy var refreshControl = UIRefreshControl().then {
        $0.tintColor = grayColor
        $0.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = $0
    }
    
    // loading indicator
    lazy var indicator = UIActivityIndicatorView().then {
        $0.color = grayColor
    }
    
    // current page index
    private var startIndex = 0
    private var totalItems: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        view.backgroundColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupLayout() {
        
        view.addSubview(headerView)
        headerView.addSubViews([backButton, searchTextField, clearButton])
        
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
        
        // collection view
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        // loading indicator
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    
    @objc func touchClear() {
        searchTextField.text = ""
        clearButton.isHidden = true
    }
    
    @objc func refresh(_ refresh: UIRefreshControl) {
        startIndex = 0
        self.requestSearch(isRefresh: true)
    }
    
    // Indicator
    private func showLoadingView(isMore: Bool = false) {
        indicator.startAnimating()
        let offsetY = isMore ? 80 : collectionView.bounds.height - 120
        indicator.snp.updateConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(-offsetY)
        }
        
        view.layoutIfNeeded()
    }
    
    private func hideLoadingView() {
        
        indicator.snp.updateConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.indicator.stopAnimating()
        }
    }
}


// Request
extension SearchViewController {
    
    private func requestSearch(isRefresh: Bool = false) {
        
        guard let text = searchTextField.text else { return }
        guard text != "" else { return }
        
        if isRefresh == false {
            self.applySnapShot(items: []) {
                self.collectionView.isHidden = false
                self.showLoadingView()
            }
        }
        
        let path = Urls.search(startIndex: "\(startIndex)", keyword: text).path
        NetworkManager.shared.request(path: path) { (model: SearchListModel?) in
            
            self.totalItems = model?.totalItems
            
            if let model = model, let items = model.items {
                self.applySnapShot(items: items)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.hideLoadingView()
            }
            
        } failure: { error in
            print(error)
            self.hideLoadingView()
        }
    }
    
    private func requestSearchMore() {
        
        guard let text = searchTextField.text else { return }
        guard text != "" else { return }
        
        let path = Urls.search(startIndex: "\(startIndex)", keyword: text).path
        NetworkManager.shared.request(path: path) { (model: SearchListModel?) in
            
            self.totalItems = model?.totalItems
            
            if let model = model, let items = model.items {
                self.applyMoreSnapShot(items: items)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.hideLoadingView()
            }
            
        } failure: { error in
            print(error)
            self.hideLoadingView()
        }
    }
}

// UICollectionView
extension SearchViewController: UICollectionViewDelegate {
    
    private func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
                
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as? SearchCollectionCell {
                
                cell.item = item
                return cell
            }
            
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier, for: indexPath) as? SearchCollectionHeaderView else {
                return SearchCollectionHeaderView()
            }
            
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapShot(items: [ItemModel], completion: (() -> Void)? = nil) {
        
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        
        snapShot.appendItems(items, toSection: .main)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, completion: completion)
        }
    }
    
    private func applyMoreSnapShot(items: [ItemModel]) {
        
        var snapShot = dataSource.snapshot()
        
        snapShot.appendItems(items, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let item = dataSource.itemIdentifier(for: indexPath) {
            let vc = DetailViewController()
            vc.volumeId = item.id ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
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

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + UIScreen.main.bounds.height + 50) > scrollView.contentSize.height {
            if indicator.isAnimating == false && refreshControl.isRefreshing == false, self.totalItems ?? 0 > (startIndex + 40)  {
                showLoadingView(isMore: true)
                startIndex += 40
                requestSearchMore()
            }
        }
    }
}
