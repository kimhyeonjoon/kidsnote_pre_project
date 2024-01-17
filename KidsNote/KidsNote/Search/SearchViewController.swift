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
        $0.text = "asd"
        $0.textColor = .white
        $0.clearButtonMode = .whileEditing
        $0.borderStyle = .none
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    // tab
    lazy var tabView = UIView()
    // eBook
    lazy var eBookView = UIView()
    lazy var eBookLabel = UILabel().then {
        $0.text = "eBook"
        $0.textColor = blueColor
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    lazy var eBookLine = UIView().then {
        $0.backgroundColor = blueColor
    }
    lazy var eBookButton = UIButton().then {
        $0.isSelected = true
        
        $0.tag = 0
        $0.addTarget(self, action: #selector(touchTab(_:)), for: .touchUpInside)
    }
    

    // audio Book
    lazy var aBookView = UIView()
    lazy var aBookLabel = UILabel().then {
        $0.text = "오디오북"
        $0.textColor = grayColor
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    lazy var aBookLine = UIView().then {
        $0.backgroundColor = blueColor
        $0.isHidden = true
    }
    lazy var aBookButton = UIButton().then {
        $0.tag = 1
        $0.addTarget(self, action: #selector(touchTab(_:)), for: .touchUpInside)
    }
    
    
    // collection view
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        setupLayout()
    }
    
    func setupLayout() {
        
        view.addSubview(headerView)
        headerView.addSubViews([backButton, searchTextField])
        
        // header
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        backButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.top.leading.bottom.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(25)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // tab
        view.addSubview(tabView)
        tabView.addSubViews([eBookView, aBookView])
        eBookView.addSubViews([eBookLabel, eBookLine, eBookButton])
        aBookView.addSubViews([aBookLabel, aBookLine, aBookButton])
        
        tabView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        eBookView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(tabView.snp.centerX)
        }
        aBookView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(tabView.snp.centerX)
        }
        
        
        // eBook
        eBookLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        eBookLine.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalTo(eBookLabel.snp.width)
            $0.height.equalTo(2)
        }
        eBookButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // audio book
        aBookLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        aBookLine.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalTo(aBookLabel.snp.width)
            $0.height.equalTo(2)
        }
        aBookButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    @objc func touchTab(_ sender: UIButton) {
        
        print(sender.tag)
        
        eBookButton.isSelected = sender.tag == 0
        aBookButton.isSelected = sender.tag == 1
        
        eBookLabel.textColor = sender.tag == 0 ? blueColor : grayColor
        aBookLabel.textColor = sender.tag == 0 ? grayColor : blueColor
        
        eBookLine.isHidden = sender.tag == 1
        aBookLine.isHidden = sender.tag == 0
        
        if sender.tag == 0 {
            // eBook
            let str = Urls.search(keyword: "꽃").path
            NetworkManager.shared.request(path: str) { (item: SearchListModel?) in
                print(item)
            } failure: { error in
                print(error)
            }


        } else {
            // audio book
        }
    }

}

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

