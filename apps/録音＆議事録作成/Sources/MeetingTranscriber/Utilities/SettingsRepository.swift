import Foundation

protocol SettingsRepository {
    func load() -> AppSettings
    func save(_ settings: AppSettings)
}

final class UserDefaultsSettingsRepository: SettingsRepository {
    private let userDefaults: UserDefaults
    private let key = "app.settings"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> AppSettings {
        guard
            let data = userDefaults.data(forKey: key),
            let decoded = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return .default
        }
        return decoded
    }

    func save(_ settings: AppSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        userDefaults.set(data, forKey: key)
    }
}
