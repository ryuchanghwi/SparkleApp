import Combine
import UIKit

protocol NavigationBarProtocol: ObservableObject {
    var dismissButtonTapPublisher: PassthroughSubject<Void, Never> { get set }
}

class BattleProgressViewModel: ObservableObject {
    @Published var imagePath: URL?
    @Published var missionContent: String = ""
    @Published var misstionTitle: String = ""
    @Published var rule: String = ""
    @Published var tip: String = ""
    @Published var misstionTool: MisstionToolCase = .unknown
    private let roundBattleMissionUseCase: RoundBattleMissionUseCaseProtocol
    private let homeGetUseCase: HomeGetUseCaseProtocol
    private let viewController: UIViewController
    private let navigationController: UINavigationController
    init(roundBattleMissionUseCase: RoundBattleMissionUseCaseProtocol, homeGetUseCase: HomeGetUseCaseProtocol, viewController: UIViewController, navigationController: UINavigationController) {
        self.roundBattleMissionUseCase = roundBattleMissionUseCase
        self.homeGetUseCase = homeGetUseCase
        self.viewController = viewController
        self.navigationController = navigationController
        getHomeData { [weak self] roundId in
            guard let self = self else { return }
            getRoundBattleData(roundId: roundId)
        }
    }
    let missionCompleteButtonTapSubject = PassthroughSubject<Void, Never>()
    let missionFailureButtonTapSubject = PassthroughSubject<Void, Never>()
    let timerButtonTapSubejct = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    // MARK: - Custom Method
    func getHomeData(successCompletion: @escaping ((Int) -> Void)) {
        homeGetUseCase.excute().sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let errorType):
                self.errorResponse(status: errorType)
            case .finished:
                break
            }
        } receiveValue: { data in
            let roundId = BattleProgressHomeGetItemViewData(homeGetDTO: data).roundId
            successCompletion(roundId)
        }.store(in: &cancellables)
    }
    func getRoundBattleData(roundId: Int) {
        roundBattleMissionUseCase.execute(roundId: roundId).sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let errorType):
                self.errorResponse(status: errorType)
            case .finished:
                break
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }
            let misstionData = RoundBattleMisstionItemViewData(roundBattleMissionDTO: data)
            imagePath = misstionData.imagePath
            misstionTitle = misstionData.misstionTitle
            missionContent = misstionData.misstionContent
            misstionTool = misstionData.misstionTool
            rule = misstionData.rule
            tip = misstionData.tip
        }.store(in: &cancellables)
    }
    func dismissViewController() {
        viewController.dismiss(animated: true)
    }
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController.pushViewController(viewController, animated: true)
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
