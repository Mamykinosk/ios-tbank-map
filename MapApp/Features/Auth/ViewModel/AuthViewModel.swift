import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var username = ""

    var errorMessage: String?
    var infoMessage: String?
    var isLoading = false

    func loginUser() {
        guard validateLogin() else { return }

        runAuthTask {
            _ = try await AuthService.shared.signIn(
                email: self.sanitizedEmail,
                password: self.password
            )
            self.clearSensitiveFields()
        }
    }

    func registerUser() {
        guard validateRegistration() else { return }

        runAuthTask {
            _ = try await AuthService.shared.register(
                email: self.sanitizedEmail,
                password: self.password,
                username: self.sanitizedUsername
            )
            self.clearSensitiveFields()
        }
    }

    func sendPasswordReset() {
        guard validateRecovery() else { return }

        runAuthTask {
            try await AuthService.shared.sendPasswordReset(email: self.sanitizedEmail)
            self.infoMessage = "Ссылка для сброса пароля отправлена на \(self.sanitizedEmail)."
        }
    }

    func clearFeedback() {
        errorMessage = nil
        infoMessage = nil
    }

    private var sanitizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private var sanitizedUsername: String {
        username.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func validateLogin() -> Bool {
        clearFeedback()

        guard isValidEmail(sanitizedEmail) else {
            errorMessage = "Введите корректный email."
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Пароль должен содержать минимум 6 символов."
            return false
        }

        return true
    }

    private func validateRegistration() -> Bool {
        clearFeedback()

        guard sanitizedUsername.count >= 3 else {
            errorMessage = "Никнейм должен содержать минимум 3 символа."
            return false
        }

        guard validateLogin() else {
            return false
        }

        guard confirmPassword == password else {
            errorMessage = "Пароли не совпадают."
            return false
        }

        return true
    }

    private func validateRecovery() -> Bool {
        clearFeedback()

        guard isValidEmail(sanitizedEmail) else {
            errorMessage = "Введите корректный email."
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: emailPattern) != nil
    }

    private func clearSensitiveFields() {
        password = ""
        confirmPassword = ""
    }

    private func runAuthTask(_ operation: @escaping @MainActor () async throws -> Void) {
        clearFeedback()
        isLoading = true

        Task {
            do {
                try await operation()
            } catch {
                errorMessage = mapAuthError(error)
            }

            isLoading = false
        }
    }

    private func mapAuthError(_ error: Error) -> String {
        let nsError = error as NSError

        guard nsError.domain == AuthErrorDomain,
              let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Не удалось выполнить запрос. Попробуйте еще раз."
        }

        switch code {
        case .invalidEmail:
            return "Email указан в неверном формате."
        case .emailAlreadyInUse:
            return "Пользователь с таким email уже существует."
        case .weakPassword:
            return "Слишком слабый пароль. Используйте минимум 6 символов."
        case .wrongPassword, .invalidCredential:
            return "Неверный email или пароль."
        case .userNotFound:
            return "Пользователь с таким email не найден."
        case .networkError:
            return "Проблема с сетью. Проверьте интернет и попробуйте еще раз."
        case .tooManyRequests:
            return "Слишком много попыток. Повторите вход немного позже."
        default:
            return nsError.localizedDescription
        }
    }
}
