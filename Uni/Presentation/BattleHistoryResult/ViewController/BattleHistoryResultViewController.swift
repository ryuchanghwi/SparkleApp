import UIKit
import Combine
import Then
import SDSKit
import SkeletonView

final class BattleHistoryResultViewController: BaseViewController {
    // MARK: - Property
    private let viewModel = BattleHistoryResultViewModel(battleHistoryResultUsecase: BattleHistoryResultUseCase(battleHistoryResultRepository: BattleHistoryResultRepository(service: GetServiceCombine.shared)))
    private lazy var loadViewSubject = PassthroughSubject<Void, Never>()
    private lazy var input =  BattleHistoryResultViewModel.Input(viewLoad: loadViewSubject.eraseToAnyPublisher())
    private lazy var output = viewModel.transform(input: input)
    private var historyData: [BattleHistoryResultDTO] = []
    // MARK: - UI Property
    private var historyView = HistoryView()
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        historyView = HistoryView(frame: self.view.frame)
        self.view = historyView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setLayout()
        historyNaviActions()
        startSkeletonView()
        setupBinding()
    }
    // MARK: - Setting
    private func setupBinding() {
        output.loadBattleHistoryResultData.sink { [weak self] completion in
            guard let self = self else { return }
            print(completion)
            switch completion {
            case .failure(let errorType):
                errorResponse(status: errorType)
            case .finished:
                break
            }
        } receiveValue: { data in
            print(data)
            self.historyData = data
            let hasData = self.historyListHasData(data: data)
            self.historyDataHasData(hasData: hasData)
        }.store(in: &cancellables)
        loadViewSubject.send(())
    }
    private func setDelegate() {
        historyView.historyTableView.dataSource = self
        historyView.historyTableView.delegate = self
    }
    // MARK: - Action Helper
    func historyNaviActions() {
        self.historyView.navigationBar.backButtonCompletionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: - Custom Method
    private func historyListHasData(data: [BattleHistoryResultDTO]) -> Bool {
        return data.count == 0 ? false : true
    }
    private func historyDataHasData(hasData: Bool) {
        DispatchQueue.main.async {
            self.view.hideSkeleton()
            self.historyView.hasHistoryData(hasData: hasData)
            if hasData {
                self.historyView.historyTableView.reloadData()
            }
        }
    }
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    func startSkeletonView() {
        self.view.isSkeletonable = true
        historyView.historyTableView.isSkeletonable = true
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        historyView.historyTableView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.gray150, .gray100]), animation: skeletonAnimation, transition: .crossDissolve(2))
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
}
// MARK: - UITableView Delegate
extension BattleHistoryResultViewController: UITableViewDelegate {
}
// MARK: - UITableView DataSource
extension BattleHistoryResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count // 뷰 컨에 보일 셀 수
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none // 셀 눌렀을 때 클릭한 거 안 보이게
        cell.configureCell(historyData: BattleHistoryItemViewData(battleHistoryItem: historyData[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let historyDetailViewController = BattleHistoryDetailViewController()
        historyDetailViewController.connectData(data: historyData[indexPath.row])
        navigationController?.pushViewController(historyDetailViewController, animated: true)
    }
}
extension BattleHistoryResultViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return HistoryTableViewCell.identifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        skeletonView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath)
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}
