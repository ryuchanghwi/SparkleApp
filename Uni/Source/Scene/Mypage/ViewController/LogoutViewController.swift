//
//  LogoutViewController.swift
//  Uni
//
//  Created by 홍유정 on 2023/07/17.
//

import UIKit

final class LogoutViewController: BaseViewController {

    private let keyChains = HeaderUtils()

    var logoutView = LogoutView()

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutViewActions()
        logoutDoneActions()
    }

    override func loadView() {
        super.loadView()
        setStyle()
    }

}

extension LogoutViewController {

    func setStyle() {
        logoutView = LogoutView(frame: self.view.frame)
        self.view = logoutView
    }

    func logoutViewActions() {
        self.logoutView.askLogoutAlertView.cancelButtonTapCompletion = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.dismiss(animated: true)
        }
    }

    func logoutDoneActions() {
        self.logoutView.askLogoutAlertView.okButtonTapCompletion = { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.keyChains.isTokenExists(account: "accessToken") {
                strongSelf.keyChains.delete("accessToken")
                UserDefaultsManager.shared.delete(.hasOnboarded)
                UserDefaultsManager.shared.delete(.isAlreadyFinish)
                UserDefaultsManager.shared.delete(.lastRoundId)
                UserDefaultsManager.shared.delete(.userId)
                UserDefaultsManager.shared.delete(.partnerId)
                let loginViewController = LoginViewController()
                strongSelf.changeRootViewController(UINavigationController(rootViewController: loginViewController))
            }
        }
    }

    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }

}
