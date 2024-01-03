import SwiftUI
import SDSKit

struct MyPageServiceButton: View {
    // MARK: - Property
    let title: String
    let action: (() -> Void)
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    // MARK: - UI Property
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Text(title)
                    .foregroundColor(Color(uiColor: .gray600))
                    .font(Font(SDSFont.body2.font))
                    .padding(.leading, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
    }
}
