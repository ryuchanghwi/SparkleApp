import SwiftUI
import UIKit
import SDSKit

struct BattleProgressView: View {
    @ObservedObject var data: BattleProgressViewModel
    @State private var currentPage = 0
    var body: some View {
        VStack(spacing: 0) {
            SDSNavigationView(style: .leftTitleRightDismissButton(title: "한판 승부 진행 중", dismissImage: Image(uiImage: SDSIcon.icDismiss), action: {
                data.dismissButtonTapPublisher.send()
            }))
            ScrollView {
                BattleHistoryCategoryTitleView(title: "나의 미션은")
                HStack(alignment: .center, spacing: 20) {
                    AsyncImage(url: URL(string: data.rountBattle?.myRoundMission?.missionContent.missionCategory.image ?? "")) { image in
                        image.image?.resizable()
                    }
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(data.rountBattle?.myRoundMission?.missionContent.content ?? "")")
                            .font(Font(SDSFont.subTitle.font))
                            .foregroundColor(Color(uiColor: .gray600))
                        Text("\(data.rountBattle?.myRoundMission?.missionContent.missionCategory.title ?? "")")
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
                BattleHistoryCategoryTitleView(title: "게임 사용법")
                TabView(selection: $currentPage) {
                    BattleHistoryGameProcessContentView(content: data.rountBattle?.myRoundMission?.missionContent.missionCategory.rule ?? "", title: "룰 소개")
                        .tag(0)
                    BattleHistoryGameProcessContentView(content: data.rountBattle?.myRoundMission?.missionContent.missionCategory.tip ?? "", title: "공략 팁")
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(width: UIScreen.main.bounds.size.width, height: 283)
                BattleHistoryPageControlView(numberOfPages: 2, currentPage: $currentPage)
                if data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "TIMER" ||
                    data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "MEMO" {
                    BattleHistoryCategoryTitleView(title: "기록하며 플레이")
                    HStack(alignment: .center, spacing: 0) {
                        Image(data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "TIMER" ? "icTimer" : (data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "MEMO" ? "icMemo" : ""))
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.leading, 18)
                        Text(data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "TIMER" ? "타이머" : (data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool == "MEMO" ? "메모" : ""))
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
                        let tool = data.rountBattle?.myRoundMission?.missionContent.missionCategory.missionTool
                        if tool == "MEMO" {
                            data.memoButtonTapSubject.send()
                        }
                        else if tool == "TIMER" {
                            data.timerButtonTapSubejct.send()
                        }
                    }
                }
            }
            BattleHistoryBottomView(viewData: data)
        }
        .background(Color(uiColor: .gray100))
    }
}
