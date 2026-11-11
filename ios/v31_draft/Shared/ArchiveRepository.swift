import Foundation

// V3.1 draft: offline-first registry. This source is built from the repository's
// data/entries_v2.json and data/photos_v2.json. No automatic remote updates.
struct ArchiveEntry: Codable, Identifiable, Hashable {
    let id: String
    let kind: String
    let date: String?
    let precision: String
    let originalTR: String
    let translationFR: String
    let titleFR: String
    let titleTR: String
    let contextFR: String
    let contextTR: String
    let theme: String
    let sourceTitle: String
    let sourceURL: String
    let photoId: String

    var isQuote: Bool { kind == "quote" }
}

struct ArchivePhoto: Codable, Identifiable, Hashable {
    let id: String
    let label: String
    let institution: String
    let approxYear: String
    let url: String
    let sourceUrl: String
    let license: String
    let originalWidth: Int?
    let originalHeight: Int?
    let mediaType: String
    let note: String?
}

enum ArchiveRepository {
    static let entries: [ArchiveEntry] = decode("entries_v2", as: [ArchiveEntry].self) ?? []
    static let photos: [ArchivePhoto] = decode("photos_v2", as: [ArchivePhoto].self) ?? []
    private static let photoByID = Dictionary(photos.map { ($0.id, $0) },
                                              uniquingKeysWith: { first, _ in first })

    static func entry(id: String) -> ArchiveEntry? {
        entries.first { $0.id == id }
    }

    static func photo(for record: ArchiveEntry) -> ArchivePhoto? {
        photoByID[record.photoId]
    }

    static func sameCalendarDay(_ record: ArchiveEntry, as date: Date) -> Bool {
        guard record.precision == "day",
              let stored = record.date,
              stored.count == 10 else { return false }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "MM-dd"
        return String(stored.suffix(5)) == formatter.string(from: date)
    }

    // Today's exact-day records first, then a stable chronological list.
    // Year-only dates are intentionally NOT assigned an invented month or day.
    static func selectionFeed(on date: Date = .now) -> [ArchiveEntry] {
        let ordered = entries.sorted {
            let a = $0.date ?? ""
            let b = $1.date ?? ""
            return a == b ? $0.id < $1.id : a < b
        }
        let today = ordered.filter { sameCalendarDay($0, as: date) }
        return today + ordered.filter { !sameCalendarDay($0, as: date) }
    }

    static func dailySelection(on date: Date = .now) -> ArchiveEntry? {
        selectionFeed(on: date).first
    }

    static func historicalDate(_ record: ArchiveEntry, language: String) -> String {
        guard let value = record.date else { return language == "tr" ? "Tarih bilinmiyor" : "Date non établie" }
        if record.precision == "year" { return value }
        let input = DateFormatter()
        input.calendar = Calendar(identifier: .gregorian)
        input.locale = Locale(identifier: "en_US_POSIX")
        input.timeZone = TimeZone(secondsFromGMT: 0)
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: value) else { return value }
        return date.formatted(.dateTime.day().month(.wide).year()
            .locale(Locale(identifier: language == "tr" ? "tr_TR" : "fr_FR")))
    }

    private static func decode<T: Decodable>(_ name: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
