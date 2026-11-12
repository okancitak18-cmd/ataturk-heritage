import Foundation
import WidgetKit

// Target membership: include this file in both the app and the WidgetKit extension.
// The App Group identifier MUST match the capability configured for both targets.
enum HeritageSharedState {
    static let appGroupID = "group.ataturkheritage.shared" // Proposed, not provisioned.
    private static let selectedIDKey = "heritage.selected.entry"
    private static let selectedDayKey = "heritage.selected.day"

    // Free Apple Account edition has no provisioned App Group and no widgets.
    #if HERITAGE_FREE_PERSONAL
    private static var store: UserDefaults? { .standard }
    #else
    private static var store: UserDefaults? { UserDefaults(suiteName: appGroupID) }
    #endif

    private static func reloadWidgetsIfAvailable() {
        #if !HERITAGE_FREE_PERSONAL
        WidgetCenter.shared.reloadTimelines(ofKind: "AtaturkHeritageDaily")
        #endif
    }
    private static func dayStamp(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    static func currentEntry(on date: Date = .now) -> ArchiveEntry? {
        let feed = ArchiveRepository.selectionFeed(on: date)
        guard !feed.isEmpty else { return nil }
        guard let store, store.string(forKey: selectedDayKey) == dayStamp(date),
              let saved = store.string(forKey: selectedIDKey),
              let found = feed.first(where: { $0.id == saved }) else { return feed.first }
        return found
    }

    @discardableResult
    static func move(_ direction: Int, on date: Date = .now) -> ArchiveEntry? {
        guard let store else { return nil } // Do not claim sharing without App Group.
        let feed = ArchiveRepository.selectionFeed(on: date)
        guard !feed.isEmpty else { return nil }
        let currentID = currentEntry(on: date)?.id
        let current = feed.firstIndex(where: { $0.id == currentID }) ?? 0
        let next = (current + (direction >= 0 ? 1 : -1) + feed.count) % feed.count
        let record = feed[next]
        store.set(record.id, forKey: selectedIDKey)
        store.set(dayStamp(date), forKey: selectedDayKey)
        reloadWidgetsIfAvailable()
        return record
    }

    static func selectOnAppOpen(_ id: String) {
        guard ArchiveRepository.entry(id: id) != nil, let store else { return }
        store.set(id, forKey: selectedIDKey)
        store.set(dayStamp(.now), forKey: selectedDayKey)
        reloadWidgetsIfAvailable()
    }
}

enum HeritageDeepLink {
    static func url(for entryID: String) -> URL? {
        var parts = URLComponents()
        parts.scheme = "ataturkheritage"
        parts.host = "entry"
        parts.path = "/" + entryID
        return parts.url
    }

    static func entryID(from url: URL) -> String? {
        guard url.scheme == "ataturkheritage", url.host == "entry" else { return nil }
        let rawID = String(url.path.dropFirst())
        guard !rawID.isEmpty, !rawID.contains("/") else { return nil }
        return ArchiveRepository.entry(id: rawID)?.id
    }
}
