//
//  SettingViewController.swift
//  Uni
//
//  Created by 홍유정 on 2023/07/14.
//

import UIKit
import SDSKit
import Then

final class SettingViewController: UIViewController {

    var settingView: SettingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        settingView = SettingView(frame: self.view.frame)
        self.view = settingView
    }

}
