import SwiftUI
import UIKit
import CryptoKit

// Heritage remains the default. Republic is an artistic interpretation; no
// unverified claim of an exact official 1923 flag shade is implied.
struct HeritageDesign {
    let theme: String
    let dark: Bool

    private var republic: Bool { theme == "republic" }
    private var archive: Bool { theme == "archive" }

    var canvas: Color {
        if dark { return Color(red: 0.11, green: 0.12, blue: 0.13) }
        return archive ? Color(red: 0.925, green: 0.91, blue: 0.87) :
            Color(red: 0.963, green: 0.951, blue: 0.928)
    }
    var paper: Color {
        if dark { return Color(red: 0.17, green: 0.18, blue: 0.19) }
        return archive ? Color(red: 0.972, green: 0.956, blue: 0.922) : Color(red: 0.995, green: 0.988, blue: 0.973)
    }
    var ink: Color { dark ? Color(red: 0.96, green: 0.94, blue: 0.90) : Color(red: 0.19, green: 0.18, blue: 0.17) }
    var muted: Color { dark ? Color(red: 0.78, green: 0.77, blue: 0.73) : Color(red: 0.39, green: 0.37, blue: 0.35) }
    var accent: Color {
        if republic { return dark ? Color(red: 0.95, green: 0.43, blue: 0.39) : Color(red: 0.64, green: 0.16, blue: 0.19) }
        if archive { return dark ? Color(red: 0.79, green: 0.67, blue: 0.48) : Color(red: 0.48, green: 0.37, blue: 0.22) }
        return dark ? Color(red: 0.85, green: 0.56, blue: 0.59) : Color(red: 0.43, green: 0.16, blue: 0.23)
    }
    var gold: Color { dark ? Color(red: 0.77, green: 0.66, blue: 0.47) : Color(red: 0.56, green: 0.41, blue: 0.21) }
    var divider: Color { ink.opacity(dark ? 0.23 : 0.12) }
}

private struct HeritageDesignKey: EnvironmentKey {
    static let defaultValue = HeritageDesign(theme: "heritage", dark: false)
}
extension EnvironmentValues {
    var heritageDesign: HeritageDesign {
        get { self[HeritageDesignKey.self] }
        set { self[HeritageDesignKey.self] = newValue }
    }
}

actor HeritagePhotoCache {
    static let shared = HeritagePhotoCache()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 12
        config.urlCache = URLCache(memoryCapacity: 12_000_000, diskCapacity: 80_000_000)
        return URLSession(configuration: config)
    }()

    private func diskURL(_ id: String) -> URL {
        let digest = SHA256.hash(data: Data(id.utf8)).map { String(format: "%02x", $0) }.joined()
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("heritage-(digest).jpg")
    }

    // The user's device caches previously viewed images. Source archives are
    // never copied into the distributed app while their rights remain unaudited.
    func image(for photo: ArchivePhoto) async -> UIImage? {
        let file = diskURL(photo.id)
        if let data = try? Data(contentsOf: file),
           let picture = UIImage(data: data) { return picture }
        guard let url = URL(string: photo.url), url.scheme == "https" else { return nil }
        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200,
                  data.count < 8_000_000, let image = UIImage(data: data) else { return nil }
            if let jpeg = image.jpegData(compressionQuality: 0.83) {
                try? jpeg.write(to: file, options: .atomic)
            }
            return image
        } catch { return nil }
    }
}

struct ArchivePhotoView: View {
    let photo: ArchivePhoto?
    let height: CGFloat
    @Environment(\.heritageDesign) private var design
    @State private var image: UIImage?
    @State private var loading = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                design.canvas
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    VStack(spacing: 9) {
                        if loading {
                            ProgressView().tint(design.accent)
                        } else {
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 30, weight: .ultraLight))
                        }
                        Text(photo == nil ? "Aucune illustration" : "Image non disponible hors connexion")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .foregroundStyle(design.muted)
                    .padding(12)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .frame(height: height)
        .task(id: photo?.id) {
            image = nil
            guard let photo else { loading = false; return }
            loading = true
            image = await HeritagePhotoCache.shared.image(for: photo)
            loading = false
        }
        .accessibilityLabel(photo?.label ?? "Illustration indisponible")
    }
}

struct ArchiveCard: View {
    let entry: ArchiveEntry
    let exactToday: Bool
    let language: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    var showContext: () -> Void = {}
    @Environment(\.heritageDesign) private var design

    private var headline: String {
        entry.isQuote ? (language == "tr" ? entry.originalTR : entry.translationFR) :
        (language == "tr" ? entry.titleTR : entry.titleFR)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ArchivePhotoView(photo: ArchiveRepository.photo(for: entry), height: 244)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            HStack {
                Text(entry.isQuote ? "PAROLE D’ATATÜRK" : "REPÈRE HISTORIQUE")
                    .font(.system(size: 10, weight: .bold)).tracking(1.2)
                Spacer()
                Text(ArchiveRepository.historicalDate(entry, language: language))
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(design.accent)
            Text(headline.isEmpty ? entry.titleFR : headline)
                .font(.system(size: 25, weight: .regular, design: .serif))
                .foregroundStyle(design.ink)
                .fixedSize(horizontal: false, vertical: true)
            if entry.isQuote && language == "fr" {
                Text(entry.originalTR)
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(design.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Rectangle().fill(design.divider).frame(height: 1)
            HStack {
                Button(action: showContext) {
                    Label("Comprendre", systemImage: "text.book.closed")
                        .font(.system(size: 13, weight: .semibold))
                }
                .accessibilityHint("Ouvre la fiche historique complète")
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(isFavorite ? "Retirer des favoris" : "Ajouter aux favoris")
            }
            .tint(design.accent)
        }
        .padding(17)
        .background(design.paper, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(design.divider, lineWidth: 0.7))
    }
}
