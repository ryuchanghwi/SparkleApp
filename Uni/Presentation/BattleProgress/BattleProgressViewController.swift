import Combine
import UIKit
import SwiftUI

final class BattleProgressViewController: BaseViewController {
    // MARK: - Property
    let timerViewData: TimerData
    private var roundId: Int = 0
    private lazy var battleProgressViewModel = BattleProgressViewModel(roundBattleMissionUseCase: RoundBattleMissionUseCase(roundBattleMissionRepository: RoundBattleMissionRepository(service: GetServiceCombine.shared)), homeGetUseCase: HomeGetUseCase(homeGetRepository: HomeGetRepository(service: GetServiceCombine.shared)), viewController: self, navigationController: self.navigationController!)
    private var battleRepository = BattleRepository()
    private var homeRepository = HomeRepository()
    private var battleData: RoundBattleDataModel?
    // MARK: - UI Property
    private var battleHistoryHostingController: UIHostingController<BattleProgressView>!
    // MARK: - Life Cycle
    init(timerViewData: TimerData) {
        self.timerViewData = timerViewData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getRoundMissionId()
        setConfig()
        setLayout()
        addMissionCompleteButtonAction()
        addmissionFailureButtonAction()
        toolButtonAction()
    }
    // MARK: - Setting
    override func setConfig() {
        battleHistoryHostingController = UIHostingController(rootView: BattleProgressView(viewModel: battleProgressViewModel, timerViewData: timerViewData))
        self.addChild(battleHistoryHostingController)
        view.addSubview(battleHistoryHostingController.view)
        battleHistoryHostingController.didMove(toParent: self)
    }
    override func setLayout() {
        battleHistoryHostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    // MARK: - Action Helper
    private func toolButtonAction() {
        battleProgressViewModel.timerButtonTapSubejct.sink { [weak self] _ in
            guard let self = self else { return }
            let battleTimerViewController = TimerViewController(timerViewData: timerViewData)
            self.navigationController?.pushViewController(battleTimerViewController, animated: true)

        }
        .store(in: &cancellables)
    }
    private func addMissionCompleteButtonAction() {
        battleProgressViewModel.missionCompleteButtonTapSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.view.showIndicator()
            self.battleRepository.patchRoundGameData(state: true,
                                                     roundId: self.roundId) { [weak self] _ in
                guard let self = self else {return}
                // 미션 성공
                // 게임 히스토리로 이동
                self.view.removeIndicator()
                let resultVC = BattleResultViewController()
                resultVC.roundId = self.roundId
                resultVC.modalPresentationStyle = .overFullScreen
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: true) {
                  pvc.present(resultVC, animated: true, completion: nil)
                }
            }
        }
        .store(in: &cancellables)
    }
    private func addmissionFailureButtonAction() {
        battleProgressViewModel.missionFailureButtonTapSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.view.showIndicator()
            self.battleRepository.patchRoundGameData(state: false,
                                                     roundId: self.roundId) { [weak self] _ in
                guard let strongSelf = self else {return}
                // 미션 실패
                // 게임 히스토리로 이동
                strongSelf.view.removeIndicator()
                let resultVC = BattleResultViewController()
                resultVC.roundId = strongSelf.roundId
                resultVC.modalPresentationStyle = .overFullScreen
                guard let pvc = strongSelf.presentingViewController else { return }
                strongSelf.dismiss(animated: true) {
                  pvc.present(resultVC, animated: true, completion: nil)
                }
            }
        }.store(in: &cancellables)
    }
    // MARK: - Custom Method
    private func getRoundMissionId() {
        self.view.showIndicator()
        homeRepository.getHomeData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let roundId = data.roundGameId {
                    self.roundId = roundId
//                    self.getRoundMissionData(roundId: roundId)
                    self.view.removeIndicator()
                }
            case .failure(let error):
                switch error {
                case .disconnectCouple:
                    self.view.removeIndicator()
                    UserDefaultsManager.shared.delete(.partnerId)
                    UserDefaultsManager.shared.delete(.userId)
                    UserDefaultsManager.shared.delete(.lastRoundId)
                    let navigationViewController = UINavigationController(rootViewController: LoginViewController())
                case .unknown:
                    self.view.removeIndicator()
                }
            }
        }
    }
}
