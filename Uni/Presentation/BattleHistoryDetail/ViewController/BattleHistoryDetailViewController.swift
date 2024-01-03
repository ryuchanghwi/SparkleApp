import UIKit
import Combine

import Then
import SDSKit

final class BattleHistoryDetailViewController: BaseViewController {
    // MARK: - Property
    private var historyDetailData: BattleHistoryResultDTO?
    private lazy var viewModel = BattleHistoryDetailViewModel()
    private lazy var loadViewSubject = PassthroughSubject<BattleHistoryResultDTO, Never>()
    private lazy var input = BattleHistoryDetailViewModel.Input(viewLoad: loadViewSubject.eraseToAnyPublisher())
    private lazy var output = viewModel.transform(input: input)
    // MARK: - UI Property
    private var historyDetailView = HistoryDetailView()
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        historyDetailView = HistoryDetailView(frame: self.view.frame)
        self.view = historyDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        historyDetailViewDidTapBackButton()
    }
    // MARK: - Setting
    private func setupBinding() {
        guard let historyDetailData = historyDetailData else { return }
        output.historyDetailData.sink { [weak self]  data in
            guard let self = self else { return }
            self.setBind(data: data)
        }.store(in: &cancellables)
        loadViewSubject.send(historyDetailData)
    }
    private func setBind(data: BattleHistoryDetailItemViewData) {
        historyDetailView.historyDetailResultView.gameDateLabel.text = data.date
        historyDetailView.historyDetailResultView.gameImageView.kf.setImage(with: data.imagePath)
        historyDetailView.historyDetailResultView.gameNameLabel.text = data.gameTitle
        historyDetailView.historyDetailResultMissionView.myHistoryResultView.missionTitleLabel.text = data.myMissionTitle
        historyDetailView.historyDetailResultMissionView.yourHistoryResultView.missionTitleLabel.text = data.partnerMissionTitle
        historyDetailView.historyDetailResultMissionView.myHistoryResultView.bindChipText(subTitle: data.myMisstionResult, status: data.myMisstionStatus)
        historyDetailView.historyDetailResultMissionView.yourHistoryResultView.bindChipText(subTitle: data.partnerMisstionResult, status: data.partnerStatus)
        historyDetailView.historyDetailResultView.gameResultLabel.text = data.gameResult
    }
    // MARK: - Action Helper
    func historyDetailViewDidTapBackButton() {
        self.historyDetailView.navigationBar.backButtonCompletionHandler = { [weak self]  in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: - Custom Method
    func connectData(data: BattleHistoryResultDTO?) {
        historyDetailData = data
    }
}
