//
//  DetailViewController.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import UIKit

let isRead = "isRead"
let isWish = "isWish"

class DetailViewController: UIViewController {
    
    // navigation bar item
    lazy var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(touchShare))
    
    lazy var scrollView = UIScrollView()
    
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    // book info
    lazy var infoView = UIView().then {
        $0.addSeparatorLine()
    }
    lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 4
    }
    lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.numberOfLines = 2
    }
    lazy var authorLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    lazy var typeLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    // sample
    lazy var sampleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.addSeparatorLine()
    }
    lazy var sampleView = UIView()
    lazy var readButton = UIButton().then {
        $0.setTitle("샘플 읽기", for: .normal)
        $0.setTitle("읽음", for: .selected)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = grayColor.cgColor
        
        $0.setTitleColor(blueColor, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        $0.addTarget(self, action: #selector(touchRead), for: .touchUpInside)
    }
    lazy var wishButton = UIButton().then {
        $0.setTitle("위시리스트에 추가", for: .normal)
        $0.setTitle("위시리스트에서 삭제", for: .selected)
        $0.layer.cornerRadius = 4
        
        $0.backgroundColor = blueColor
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        $0.addTarget(self, action: #selector(touchWish), for: .touchUpInside)
    }
    lazy var guideView = UIView()
    lazy var guideImageView = UIButton(type: .infoLight).then {
        $0.isUserInteractionEnabled = false
    }
    lazy var guideLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다."
        $0.numberOfLines = 2
    }
    
    // description
    lazy var descView = UIView()
    lazy var descTitleLabel = UILabel().then {
        $0.text = "eBook 정보"
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    lazy var descMoreButton = UIButton().then {
        $0.setTitle(">", for: .normal)
        $0.setTitleColor(blueColor, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        $0.addTarget(self, action: #selector(touchDescriptionMore), for: .touchUpInside)
    }
    lazy var descLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 4
    }
    
    // published
    lazy var publishView = UIView()
    lazy var publishTitleLabel = UILabel().then {
        $0.text = "게시일"
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    lazy var publishLabel = UILabel().then {
        $0.textColor = grayColor
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    var volumeId: String = "" {
        didSet {
            requestDetail()
        }
    }
    var item: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    func setupLayout() {
        
        view.addSubViews([scrollView])
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews([infoView, sampleStackView, descView, publishView])
        
        // scroll view
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // stack view
        stackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
        }
        
        // info view
        infoView.addSubViews([imageView, titleLabel, authorLabel, typeLabel])
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 80, height: 120))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
        
        // sample view
        sampleStackView.addArrangedSubviews([sampleView, guideView])
        sampleView.addSubViews([readButton, wishButton])
        readButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(CGSize(width: 100, height: 30))
            
        }
        wishButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(readButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(30)
        }
        
        // guide view
        guideView.addSubViews([guideImageView, guideLabel])
        guideImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(15)
        }
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(guideImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        // description view
        descView.addSubViews([descTitleLabel, descMoreButton, descLabel])
        descTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }
        descMoreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }
        descLabel.snp.makeConstraints {
            $0.top.equalTo(descTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        // publish view
        publishView.addSubViews([publishTitleLabel, publishLabel])
        publishTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }
        publishLabel.snp.makeConstraints {
            $0.top.equalTo(publishTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        
    }
    
    func updateUI() {
        
        guard let item else {
            return
        }
        
        // info
        NetworkManager.shared.requestImage(path: item.volumeInfo?.imageLinks?.url() ?? "") { image in
            self.imageView.image = image
        } failure: { error in
            print(" failure image load")
        }
        titleLabel.text = item.titleText()
        authorLabel.text = item.authosText()
        typeLabel.text = item.eBookAveText()
        
        // sample
        if let isRead = UserDefaults.standard.object(forKey: "\(volumeId)\(isRead)") as? Bool {
            readButton.isSelected = isRead
            guideView.isHidden = isRead
        }
        if let isWish = UserDefaults.standard.object(forKey: "\(volumeId)\(isWish)") as? Bool {
            wishButton.isSelected = isWish
        }
        
        
        // description
        if let description = item.descriptionText() {
            descLabel.attributedText = description
        } else {
            descView.isHidden = true
        }
        
        // published
        if let pubData = item.volumeInfo?.publishedDate, let publisher = item.volumeInfo?.publisher {
            publishLabel.text = "\(pubData) • \(publisher)"
        } else {
            publishView.isHidden = true
        }
    }
    
    @objc func touchShare() {
        
        guard let item = self.item else {
            return
        }

        let items = [item.volumeInfo?.title, item.selfLink]

        let vc = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func touchRead() {
        readButton.isSelected = !readButton.isSelected
        UserDefaults.standard.setValue(readButton.isSelected, forKey: "\(volumeId)\(isRead)")
        guideView.isHidden = readButton.isSelected
    }
    
    @objc func touchWish() {
        wishButton.isSelected = !wishButton.isSelected
        UserDefaults.standard.setValue(wishButton.isSelected, forKey: "\(volumeId)\(isWish)")
    }
    
    @objc func touchDescriptionMore() {
        
        let vc = DescriptionViewController()
        vc.item = self.item
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Request
extension DetailViewController {
    
    func requestDetail() {
        
        let path = Urls.detail(volumeId: volumeId).path
        NetworkManager.shared.request(path: path) { (item: ItemModel?) in
            self.item = item
            self.updateUI()
        } failure: { error in
            print(error)
        }

    }
}
