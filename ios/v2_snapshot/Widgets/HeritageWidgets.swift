import WidgetKit
import SwiftUI
import Foundation
import UIKit

struct HeritageTimelineItem: TimelineEntry {
    let date: Date
    let archive: ArchiveEntry?
    let imageData: Data?
}

struct HeritageProvider: TimelineProvider {
    func placeholder(in context: Context) -> HeritageTimelineItem {
        HeritageTimelineItem(date: .now, archive: ArchiveRepository.entries.first, imageData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (HeritageTimelineItem) -> Void) {
        Task {
            completion(await loadItem(for: .now))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HeritageTimelineItem>) -> Void) {
        Task {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: .now)
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today.addingTimeInterval(86400)
            // WidgetKit holds a timeline entry until the following date.
            let first = await loadItem(for: today)
            let second = await loadItem(for: tomorrow)
            let refresh = calendar.date(byAdding: .day, value: 2, to: today) ?? tomorrow.addingTimeInterval(86400)
            completion(Timeline(entries: [first, second], policy: .after(refresh)))
        }
    }

    private func loadItem(for date: Date) async -> HeritageTimelineItem {
        let archive = ArchiveRepository.dailySelection(on: date)
        var imageData: Data? = nil
        if let archive,
           let photo = ArchiveRepository.photo(for: archive),
           let url = URL(string: photo.url) {
            var request = URLRequest(url: url)
            request.timeoutInterval = 9
            // Photographs come only from verified archival metadata URLs.
            if let (data, response) = try? await URLSession.shared.data(for: request),
               let http = response as? HTTPURLResponse,
               http.statusCode == 200,
               data.count < 5_000_000,
               UIImage(data: data) != nil {
                imageData = data
            }
        }
        return HeritageTimelineItem(date: date, archive: archive, imageData: imageData)
    }
}


/** A shortened quote must be labelled as an excerpt rather than a complete quotation.
    Boundaries are composed of Characters, which do not split grapheme clusters. */
struct HeritageWidgetExcerpt {
    let text: String
    let shortened: Bool

    static func make(_ value: String, limit: Int) -> HeritageWidgetExcerpt {
        let normalized = value.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
        guard normalized.count > limit else {
            return HeritageWidgetExcerpt(text: normalized, shortened: false)
        }
        let words = normalized.split(separator: " ")
        var preview = ""
        for word in words {
            let piece = String(word)
            if preview.count + (preview.isEmpty ? 0 : 1) + piece.count > max(1, limit - 1) { break }
            preview += (preview.isEmpty ? "" : " ") + piece
        }
        if preview.isEmpty { preview = String(normalized.prefix(max(1, limit - 1))) }
        return HeritageWidgetExcerpt(text: preview + "…", shortened: true)
    }
}

private struct HeritageWidgetText: View {
    let fullText: String
    let limit: Int
    let color: Color
    let fontSize: CGFloat

    private var excerpt: HeritageWidgetExcerpt { .make(fullText, limit: limit) }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(excerpt.text)
                .font(.system(size: fontSize, design: .serif))
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel(fullText)
            if excerpt.shortened {
                Text("EXTRAIT · OUVRIR LA FICHE")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundStyle(color.opacity(0.75))
                    .accessibilityLabel("Extrait, consulter la fiche pour lire l’intégralité")
            }
        }
    }
}

struct HeritageWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var item: HeritageTimelineItem

    private var phrase: String {
        guard let record = item.archive else { return "ATATÜRK" }
        return record.isQuote ? record.originalTR : record.titleFR
    }
    private var caption: String {
        guard let record = item.archive else { return "H E R I T A G E" }
        return record.isQuote ? record.translationFR : record.contextFR
    }
    private var date: String {
        guard let record = item.archive else { return "ARCHIVES" }
        return ArchiveRepository.sameCalendarDay(record, as: item.date) ? "CE JOUR DANS L’HISTOIRE" : "UNE PENSÉE À DÉCOUVRIR"
    }

    @ViewBuilder
    private var archivalImage: some View {
        if let data = item.imageData, let picture = UIImage(data: data) {
            Image(uiImage: picture)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                HeritageWidgetTheme.dark
                Image(systemName: "photo.artframe")
                    .font(.system(size: 30, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
    }

    var body: some View {
        Group {
            switch family {
            case .accessoryInline:
                Text("ATATÜRK · " + HeritageWidgetExcerpt.make(phrase, limit: 26).text)
                    .lineLimit(1)
                    .accessibilityLabel(phrase)
            case .accessoryRectangular:
                VStack(alignment: .leading, spacing: 3) {
                    Text("ATATÜRK · HERITAGE")
                        .font(.system(size: 10, weight: .bold)).tracking(1)
                    HeritageWidgetText(fullText: phrase, limit: 55, color: .primary, fontSize: 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            case .systemSmall:
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { geo in
                        archivalImage.frame(width: geo.size.width, height: geo.size.height).clipped()
                    }
                    LinearGradient(colors: [.clear, .black.opacity(0.28), .black.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ATATÜRK")
                            .font(.system(size: 11, weight: .semibold, design: .serif)).tracking(2)
                        Spacer()
                        HeritageWidgetText(fullText: phrase, limit: 62, color: .white, fontSize: 14)
                        Rectangle().fill(.white.opacity(0.75)).frame(width: 30, height: 1)
                    }
                    .foregroundStyle(.white)
                    .padding(14)
                }
            case .systemMedium:
                HStack(spacing: 0) {
                    archivalImage
                        .frame(width: 125)
                        .clipped()
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ATATÜRK  /  HERITAGE")
                            .font(.system(size: 9, weight: .semibold)).tracking(1.2)
                            .foregroundStyle(HeritageWidgetTheme.accent)
                        HeritageWidgetText(fullText: phrase, limit: 100, color: HeritageWidgetTheme.ink, fontSize: 17)
                        Spacer(minLength: 1)
                        Text(date)
                            .font(.system(size: 8)).tracking(0.8)
                            .foregroundStyle(HeritageWidgetTheme.muted)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(HeritageWidgetTheme.paper)
            case .systemLarge:
                VStack(alignment: .leading, spacing: 0) {
                    archivalImage.frame(height: 190).clipped()
                    VStack(alignment: .leading, spacing: 11) {
                        Text("ATATÜRK   /   HERITAGE")
                            .font(.system(size: 10, weight: .semibold)).tracking(2)
                            .foregroundStyle(HeritageWidgetTheme.accent)
                        HeritageWidgetText(fullText: phrase, limit: 210, color: HeritageWidgetTheme.ink, fontSize: 22)
                        Text(HeritageWidgetExcerpt.make(caption, limit: 160).text)
                            .font(.system(size: 12))
                            .foregroundStyle(HeritageWidgetTheme.muted)
                            .lineLimit(4)
                        Spacer(minLength: 0)
                        Text(date).font(.system(size: 9, weight: .medium)).tracking(1)
                            .foregroundStyle(HeritageWidgetTheme.accent)
                    }
                    .padding(19)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundStyle(HeritageWidgetTheme.ink)
                .background(HeritageWidgetTheme.paper)
            default:
                Text(phrase)
                    .font(.system(.caption, design: .serif))
            }
        }
        .containerBackground(for: .widget) { HeritageWidgetTheme.paper }
    }
}

enum HeritageWidgetTheme {
    static let paper = Color(red: 0.975, green: 0.967, blue: 0.947)
    static let dark = Color(red: 0.18, green: 0.19, blue: 0.17)
    static let ink = Color(red: 0.18, green: 0.19, blue: 0.17)
    static let muted = Color(red: 0.47, green: 0.46, blue: 0.43)
    static let accent = Color(red: 0.42, green: 0.13, blue: 0.18)
}

struct HeritageWidget: Widget {
    let kind = "AtaturkHeritageDaily"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HeritageProvider()) { item in
            HeritageWidgetView(item: item)
        }
        .configurationDisplayName("ATATÜRK · La pensée du jour")
        .description("Citation historique sourcée ou événement survenu à cette date.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryInline, .accessoryRectangular])
    }
}

@main
struct HeritageWidgets: WidgetBundle {
    var body: some Widget { HeritageWidget() }
}