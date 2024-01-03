import UIKit

import SDSKit
import SnapKit
import Then

final class HistoryDetailView: UIView {
    // MARK: - UI Property
    let navigationBar = SDSNavigationBar(hasBack: true, hasTitleItem: true, navigationTitle: "승부 히스토리")
    var historyDetailResultView = HistoryDetailResultView()
    var historyDetailResultMissionView = HistoryDetailResultMissionView()
    // MARK: - Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
        setStyle()
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
        setStyle()
    }
    // MARK: - Setting
    private func setStyle() {
        self.backgroundColor = .gray100
    }
    private func setLayout() {
        [navigationBar, historyDetailResultView, historyDetailResultMissionView]
            .forEach { addSubview($0) }
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        historyDetailResultView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        historyDetailResultMissionView.snp.makeConstraints {
            $0.top.equalTo(historyDetailResultView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(176)
        }
    }
}
