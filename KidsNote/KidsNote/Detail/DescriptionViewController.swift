//
//  DescriptionViewController.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/20.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    lazy var textView = UITextView().then {
        $0.isSelectable = false
        
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    var item: ItemModel? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func updateUI() {
        navigationItem.title = item?.volumeInfo?.title
        textView.attributedText = item?.descriptionText()
    }
}
