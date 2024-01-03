import Foundation
import SafariServices
import Combine
import UIKit

final class MyPageViewModel: ObservableObject {
    @Published var myPageName: String = ""
    @Published var myPageDate: String = ""
    @Published var startDate: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private let myPageGetUseCase: MyPageGetUseCaseProtocol
    private let navigationController: UINavigationController
    private let viewController: UIViewController
    init(myPageGetUseCase: MyPageGetUseCaseProtocol, navigationController: UINavigationController, viewController: UIViewController) {
        self.myPageGetUseCase = myPageGetUseCase
        self.navigationController = navigationController
        self.viewController = viewController
    }
    // MARK: - Custom Method
    func getMyPageData() {
        myPageGetUseCase.excute().sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let errorType):
                errorResponse(status: errorType)
            case .finished:
                break
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }
            self.myPageDate = MyPageGetItemViewData(myPageGetItem: data).date
            self.myPageName = MyPageGetItemViewData(myPageGetItem: data).name
            self.startDate = data.startDate ?? ""
        }
        .store(in: &cancellables)
    }
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    func pushViewController(viewController: UIViewController) {
        self.navigationController.pushViewController(viewController, animated: true)
    }
    func safariPresent(link: String) {
        let termsOfUseUrl = NSURL(string: link)
        let termsOfUseUrlSafariView: SFSafariViewController = SFSafariViewController(url: termsOfUseUrl! as URL)
        viewController.present(termsOfUseUrlSafariView, animated: true, completion: nil)
    }
    func errorResponse(status: ErrorType) {
        switch status {
        case .disconnected:
            UserDefaultsManager.shared.delete(.partnerId)
            UserDefaultsManager.shared.delete(.userId)
            UserDefaultsManager.shared.delete(.lastRoundId)
            let navigationViewController = UINavigationController(rootViewController: LoginViewController())
            self.changeRootViewController(navigationViewController)
        case .unknown:
            let navigationViewController = UINavigationController(rootViewController: LoginViewController())
            self.changeRootViewController(navigationViewController)
        case .parsingError:
            return
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
