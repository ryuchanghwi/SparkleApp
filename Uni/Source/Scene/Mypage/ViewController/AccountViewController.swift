//
//  AccountViewController.swift
//  Uni
//
//  Created by 홍유정 on 2023/07/14.
//

import UIKit
import SDSKit
import Then

final class AccountViewController: BaseViewController {

    var accountView = AccountView()

    override func viewDidLoad() {
        super.viewDidLoad()
        accountNaviActions()

    }

    override func loadView() {
        super.loadView()
        setStyle()
    }

}

extension AccountViewController: AccountViewDelegate {

    func setStyle() {
        accountView = AccountView(frame: self.view.frame)
        accountView.delegate = self
        self.view = accountView
    }

    func accountNaviActions() {
        self.accountView.accountViewNavi.backButtonCompletionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }

    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0: let logoutViewController = LogoutViewController()
            logoutViewController.modalPresentationStyle = .overFullScreen
            logoutViewController.modalTransitionStyle = .crossDissolve
            self.present(logoutViewController, animated: true, completion: nil)
            // 탈퇴, 연결해제 미구현으로 주석처리

//        case 1 : let withdrawViewController = WithdrawViewController()
//            withdrawViewController.modalPresentationStyle = .overFullScreen
//            withdrawViewController.modalTransitionStyle = .crossDissolve
//            self.present(withdrawViewController, animated: true, completion: nil)
//
//        case 2 : let disconnectViewController = DisconnectViewController()
//            disconnectViewController.modalPresentationStyle = .overFullScreen
//            disconnectViewController.modalTransitionStyle = .crossDissolve
//            self.present(disconnectViewController, animated: true, completion: nil)
//
        default:
            return
        }
    }
}
