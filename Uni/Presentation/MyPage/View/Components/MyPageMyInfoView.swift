import SwiftUI
import SDSKit

struct MyPageMyInfoView: View {
    // MARK: - Property
    let name: String
    let date: String
    let action: (() -> Void)
    init(name: String, date: String, action: @escaping () -> Void) {
        self.name = name
        self.date = date
        self.action = action
    }
    // MARK: - UI Property
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .foregroundColor(Color(uiColor: .gray600))
                    .font(Font(SDSFont.title2.font))
                Text(date)
                    .foregroundColor(Color(uiColor: .gray600))
                    .font(Font(SDSFont.body2.font))
                    .padding(.top, 12)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 13)
            Spacer()
            Button {
                action()
            } label: {
                Image("pencil")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
            .padding(.top, 13)
            .padding(.trailing, 16)

        }
        .frame(height: 114)
    }
}
