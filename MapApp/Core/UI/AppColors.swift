import SwiftUI
import UIKit

extension Color {
    static let appBackground = adaptive(
        light: Color(red: 252 / 255, green: 249 / 255, blue: 244 / 255),
        dark: hex(0x0D1712)
    )
    static let appPrimary = adaptive(
        light: Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255),
        dark: hex(0xB7E2C9)
    )
    static let appSecondary = adaptive(
        light: Color(red: 65 / 255, green: 72 / 255, blue: 69 / 255),
        dark: hex(0xD7E2DB, alpha: 0.8)
    )
    static let appFieldBackground = adaptive(
        light: Color(red: 235 / 255, green: 232 / 255, blue: 227 / 255),
        dark: hex(0x1D2823)
    )
    static let appAccent = adaptive(
        light: Color(red: 45 / 255, green: 75 / 255, blue: 63 / 255),
        dark: hex(0x8FB8A3)
    )
    static let appMuted = adaptive(
        light: Color(red: 229 / 255, green: 226 / 255, blue: 221 / 255),
        dark: hex(0x2A3A31)
    )
    static let appTitle = adaptive(
        light: Color(red: 28 / 255, green: 28 / 255, blue: 25 / 255),
        dark: hex(0xEAF2ED)
    )
    static let appPlaceholder = adaptive(
        light: Color(red: 168 / 255, green: 162 / 255, blue: 158 / 255),
        dark: hex(0x91A39A)
    )
    static let appSecondaryAction = adaptive(
        light: Color(red: 67 / 255, green: 102 / 255, blue: 77 / 255),
        dark: hex(0x8FB8A3)
    )
    static let appGreenGlow = adaptive(
        light: Color(red: 194 / 255, green: 233 / 255, blue: 201 / 255),
        dark: hex(0x2A3A31)
    )
    static let appBlueGlow = adaptive(
        light: Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255),
        dark: hex(0x1D2823)
    )
    static let appError = adaptive(
        light: Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255),
        dark: hex(0xFFB4AB)
    )
    static let appErrorBackground = adaptive(
        light: Color(red: 254 / 255, green: 237 / 255, blue: 237 / 255),
        dark: hex(0x3B1716)
    )
    static let appSuccessBackground = adaptive(
        light: Color(red: 235 / 255, green: 247 / 255, blue: 238 / 255),
        dark: hex(0x183324)
    )
    static let appSurface = adaptive(
        light: .white,
        dark: hex(0x17251E)
    )
    static let appWarmSurface = adaptive(
        light: Color(red: 248 / 255, green: 249 / 255, blue: 245 / 255),
        dark: hex(0x17251E)
    )
    static let appOnPrimary = adaptive(
        light: .white,
        dark: hex(0x0B1F16)
    )
    static let appOnSecondary = adaptive(
        light: .white,
        dark: hex(0x0E2118)
    )
}

private extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            UIColor(traitCollection.userInterfaceStyle == .dark ? dark : light)
        })
    }

    static func hex(_ value: Int, alpha: Double = 1) -> Color {
        Color(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: alpha
        )
    }
}
