import SwiftUI
import SDSKit
import SafariServices

struct MyPageView: View {
    // MARK: - Property
    @ObservedObject var viewModel: MyPageViewModel
    // MARK: - UI Property
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SDSNavigationView(style: .leftPopButtonMiddleTitle(title: "마이페이지", action: {
                viewModel.popViewController()
            }))
            MyPageSubTitleView(title: "내 정보")
            MyPageMyInfoView(name: viewModel.myPageName, date: viewModel.myPageDate) {
                let editProfileViewController = EditProfileViewController()
                editProfileViewController.dataBind(userName: viewModel.myPageName, startDate: viewModel.startDate)
                viewModel.pushViewController(viewController: editProfileViewController)
            }
            MyPageSubTitleView(title: "서비스 이용")
            MyPageServiceButton(title: "계정") {
                viewModel.pushViewController(viewController: AccountViewController())
            }
            MyPageServiceButton(title: "서비스 이용약관") {
                viewModel.safariPresent(link: "https://sparkle-uni.notion.site/5852b2d5f5b24121a4b28b93a8d2e5b6?pvs=4")
            }
            MyPageServiceButton(title: "개인정보 처리 방침") {
                viewModel.safariPresent(link: "https://sparkle-uni.notion.site/aebe71410014461d85c96851bae1d5cb?pvs=4")
            }
            MyPageServiceButton(title: "오픈소스 라이브러리") {
                viewModel.safariPresent(link: "https://sparkle-uni.notion.site/00c8ee4d810e411395c7ff26d22dcffd?pvs=4")
            }
            Spacer()
        }
        .task {
            viewModel.getMyPageData()
        }
    }
}
