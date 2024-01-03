import SwiftUI
import Combine

final class QnAViewModel: ObservableObject {
    private let userRepository = UserRepository()
    private let keyChains = HeaderUtils()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func showDeleteUserAlert() {
        let alretView = self.navigationController.visibleViewController?.view.showAlert(title: "계정을 탈퇴하시겠어요?",
                                                                                        message: "모든 기록이 사라져요",
                                                                                        cancelButtonMessage: "취소",
                                                                                        okButtonMessage: "탈퇴",
                                                                                        type: .alert)
        alretView?.okButtonTapCompletion = { [weak self] in
            guard let self else {return}
            if self.keyChains.isTokenExists(account: "accessToken") {
                self.deleteUser {
                    self.keyChains.delete("accessToken")
                    UserDefaultsManager.shared.delete(.hasOnboarded)
                    UserDefaultsManager.shared.delete(.lastRoundId)
                    UserDefaultsManager.shared.delete(.userId)
                    UserDefaultsManager.shared.delete(.partnerId)
                    let loginViewController = LoginViewController()
                    self.changeRootViewController(UINavigationController(rootViewController: loginViewController))
                }
            }
        }
        
        alretView?.cancelButtonTapCompletion = { [weak self] in
            guard let self else {return}
            self.navigationController.visibleViewController?.view.hideAlert(view: alretView!)
        }
    }
    
    func deleteUser(completion: @escaping (() -> Void)) {
        if UserDefaultsManager.shared.load(.userId) as! Int == 0 {
            completion()
            return
        } else {
            userRepository.deleteUserData { data in
                print("userdelete:", data.code)
                completion()
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
            self.navigationController.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
}
