import SwiftUI

struct MemoryFormField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var height: CGFloat = 55
    var isMultiline = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary)

            if isMultiline {
                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(height: height)
                    .background(Color.appMuted.opacity(0.5))
                    .overlay(alignment: .topLeading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.appPlaceholder)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 18)
                        }
                    }
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.appPlaceholder))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .padding(.horizontal, 16)
                    .frame(height: height)
                    .background(Color.appMuted.opacity(0.5))
            }
        }
    }
}
