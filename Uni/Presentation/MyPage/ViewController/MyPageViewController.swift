import UIKit
import SafariServices
import SwiftUI

import SDSKit
import Then

final class MyPageViewController: BaseViewController {
    // MARK: - Property
    private let myPageTitleList = MyPageTitle.myPageTitleList()
    private lazy var myPageViewModel = MyPageViewModel(myPageGetUseCase: MyPageGetUseCase(myPageGetRepository: MyPageGetRepository(service: GetServiceCombine.shared)), navigationController: self.navigationController!, viewController: self)
    // MARK: - UI Property
    private var myPageHostingController: UIHostingController<MyPageView>!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfig()
        setLayout()
    }
    // MARK: - Setting
    override func setConfig() {
        super.setConfig()
        myPageHostingController = UIHostingController(rootView: MyPageView(viewModel: myPageViewModel))
        self.addChild(myPageHostingController)
        view.addSubview(myPageHostingController.view)
        myPageHostingController.didMove(toParent: self)
    }
    override func setLayout() {
        super.setLayout()
        myPageHostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
