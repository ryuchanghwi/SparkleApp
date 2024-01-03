import SwiftUI
import SDSKit

struct MyPageSubTitleView: View {
    // MARK: - Property
    let title: String
    init(title: String) {
        self.title = title
    }
    // MARK: - UI Property
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundColor(Color(uiColor: .lightBlue600))
                .font(Font(SDSFont.body2.font))
                .padding(.leading, 16)
            Spacer()
        }
        .frame(height: 34)
    }
}
