import SwiftUI
import UIKit
import SDSKit

struct BattleProgressView: View {
    @ObservedObject var viewModel: BattleProgressViewModel
    @ObservedObject var timerViewData: TimerData
    @State private var currentPage = 0
    var body: some View {
        VStack(spacing: 0) {
            SDSNavigationView(style: .leftTitleRightDismissButton(title: "한판 승부 진행 중", dismissImage: SDSIcon.icDismiss, action: {
                viewModel.dismissViewController()
            }))
            ScrollView {
                VStack(spacing: 0) {
                    myMissitonCategory
                    gameUsageCategory
                    recordToolCategory
                }
            }
            BattleHistoryBottomView(viewData: viewModel)
        }
        .background(Color(uiColor: .gray100))
    }
}

extension BattleProgressView {
    private var myMissitonCategory: some View {
        VStack(spacing: 0) {
            BattleHistoryCategoryTitleView(title: "나의 미션은")
            HStack(alignment: .center, spacing: 20) {
                AsyncImage(url: viewModel.imagePath) { image in
                    image.image?.resizable()
                }.frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.missionContent)
                        .font(Font(SDSFont.subTitle.font))
                        .foregroundColor(Color(uiColor: .gray600))
                    Text(viewModel.misstionTitle)
                        .font(Font(SDSFont.body1.font))
                        .foregroundColor(Color(uiColor: .gray600))
                }
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .frame(height: 100)
            .background(Color(uiColor: .gray000))
            .cornerRadius(10)
            .padding([.leading, .trailing], 20)
        }
    }
    private var gameUsageCategory: some View {
        VStack(spacing: 0) {
            BattleHistoryCategoryTitleView(title: "게임 사용법")
            TabView(selection: $currentPage) {
                BattleHistoryGameProcessContentView(content: viewModel.rule, title: "룰 소개")
                    .tag(0)
                BattleHistoryGameProcessContentView(content: viewModel.tip, title: "공략 팁")
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: UIScreen.main.bounds.size.width, height: 283)
            BattleHistoryPageControlView(numberOfPages: 2, currentPage: $currentPage)
        }
    }
    private var recordToolCategory: some View {
        VStack(spacing: 0) {
            if viewModel.misstionTool == .memo || viewModel.misstionTool == .timer {
                BattleHistoryCategoryTitleView(title: "기록하며 플레이")
                HStack(alignment: .center, spacing: 0) {
                    Image(viewModel.misstionTool == .memo ? "icMemo" : (viewModel.misstionTool == .timer ? "icTimer" : ""))
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.leading, 18)
                    Text(viewModel.misstionTool == .memo ? "메모" : (viewModel.misstionTool == .timer ? "타이머" : ""))
                        .font(Font(SDSFont.btn2.font))
                        .padding(.leading, 14)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.size.width - 40, height: 85)
                .shadow(color: Color(red: 0.67, green: 0.73, blue: 0.73).opacity(0.12), radius: 12.5, x: 6, y: 7)
                .shadow(color: Color(red: 0.91, green: 0.94, blue: 0.94), radius: 5, x: -3, y: -3)
                .background(Color(uiColor: .gray000))
                .cornerRadius(10)
                .padding(.bottom, 28)
                .onTapGesture {
                    switch viewModel.misstionTool {
                    case .memo:
                        viewModel.pushViewController(BattleMemoViewController())
                    case .timer:
                        viewModel.pushViewController(TimerViewController(timerViewData: timerViewData))
                    case .unknown:
                        return
                    }
                }
            }
        }
    }
}
