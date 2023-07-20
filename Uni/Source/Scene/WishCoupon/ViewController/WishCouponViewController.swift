//
//  WishCouponViewController.swift
//  Uni
//
//  Created by 김사랑 on 2023/07/16.
//

import UIKit
import Then
import SDSKit
import CHTCollectionViewWaterfallLayout

class WishCouponViewController: BaseViewController {
    private var myWishCouponData: Int = 0 {
        didSet {
            if myWishCouponData == 0 {
                wishCouponView.wishCouponCollectionView.backgroundColor = .clear
                wishCouponView.wishCouponData2 = myWishCouponData
            }
            else {
                wishCouponView.wishCouponCollectionView.backgroundColor = .gray100
                wishCouponView.wishCouponData2 = myWishCouponData
            }
        }
    }
    var yourWishCouponData: Int = 0 {
        didSet {
            if yourWishCouponData == 0 {
                wishCouponView.wishCouponYourCollectionView.backgroundColor = .clear
                wishCouponView.wishCouponData2 = yourWishCouponData
            }
            else {
                wishCouponView.wishCouponYourCollectionView.backgroundColor = .gray100
                wishCouponView.wishCouponYourCollectionView.wishCouponData = yourWishCouponData // wishCouponData가 겹치지 않도록 상대소원권 컬렉션뷰에 따로 뺌
            }
        }
    }
    
    // MARK: - Property
    
    private var wishCouponView = WishCouponView()
    
    private let wishCouponRepository = WishCouponRepository()
    

    
    // MARK: - UI Property
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        actions()
        
    }
    
    override func loadView() {
        super.loadView()
        
        wishCouponView = WishCouponView(frame: self.view.frame)
        self.view = wishCouponView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wishCouponRepository.getWishCouponData { data in
            print(data)
            self.configureData(wishCouponData: data)
            self.wishCouponView.wishCouponData = data
        }
    }
    
    // MARK: - Setting
    
    private func setStyle() {
    }
    
    override func setLayout() {
        
    }
    
    // MARK: - Action Helper
    
    private func actions() {
        wishCouponView.wishCouponCountView.myButton.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
        wishCouponView.wishCouponCountView.yourButton.addTarget(self, action: #selector(yourButtonTapped), for: .touchUpInside)
    }
    
    @objc func myButtonTapped() {
        switchToMyWishCouponView(showMyWishCoupon: true)
//        let data = WishCouponYourCollectionView.wishCouponYourData {
//            self.configureCell(wishCouponData: data)
//        }
        

        print("switchMyButton")

    }
    
    @objc func yourButtonTapped() {
        switchToMyWishCouponView(showMyWishCoupon: false)
        print("switchYourButton")
    }
    
    // MARK: - Custom Method
    private func switchToMyWishCouponView(showMyWishCoupon: Bool) {
        if showMyWishCoupon {
            /// 나의 소원권
            
            DispatchQueue.main.async {
                self.wishCouponView.wishCouponEmptyView.noneLabel.text = ""
                self.wishCouponView.wishCouponCollectionView.isHidden = false
                self.wishCouponView.wishCouponYourCollectionView.isHidden = true
                self.wishCouponView.wishCouponCountView.yourButton.setTitleColor(.gray300, for: .normal)
                self.wishCouponView.wishCouponCountView.yourButton.titleLabel?.font = SDSFont.body1Regular.font
                self.wishCouponView.wishCouponCountView.myButton.setTitleColor(.lightBlue600, for: .normal)
                self.wishCouponView.wishCouponCountView.myButton.titleLabel?.font = SDSFont.subTitle.font
                self.wishCouponView.wishCouponCollectionView.scrollToInitialPosition()
            }
        }
        else {
            /// 상대 소원권
            DispatchQueue.main.async {
                self.wishCouponView.wishCouponEmptyView.noneLabel.text = "아직 상대의 소원권이 없어요!"
                self.wishCouponView.wishCouponCollectionView.isHidden = true
                self.wishCouponView.wishCouponYourCollectionView.isHidden = false
                self.wishCouponView.wishCouponCountView.myButton.setTitleColor(.gray300, for: .normal)
                self.wishCouponView.wishCouponCountView.myButton.titleLabel?.font = SDSFont.body1Regular.font
                self.wishCouponView.wishCouponCountView.yourButton.setTitleColor(.lightBlue600, for: .normal)
                self.wishCouponView.wishCouponCountView.yourButton.titleLabel?.font = SDSFont.subTitle.font
                self.wishCouponView.wishCouponYourCollectionView.scrollToInitialPosition()
            }
        }
        
    }
    
    func configureData(wishCouponData: WishCouponDataModel) {
        wishCouponView.wishCouponCountView.countLabel.text = "사용 가능한 소원권이 \(wishCouponData.availableWishCoupon ?? 0)개 있어요"
    
        
    }
}

