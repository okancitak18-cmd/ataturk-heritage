import SwiftUI

// Provisional palette for the native prototype. Republic historical red pending validation.
enum HeritagePalette {
    static let paper = Color(red: 0.975, green: 0.967, blue: 0.947)
    static let canvas = Color(red: 0.952, green: 0.938, blue: 0.905)
    static let ink = Color(red: 0.20, green: 0.18, blue: 0.17)
    static let muted = Color(red: 0.48, green: 0.44, blue: 0.41)
    static let bordeaux = Color(red: 0.45, green: 0.17, blue: 0.23)
    static let gold = Color(red: 0.64, green: 0.51, blue: 0.36)
}

struct ArchivePhotoView: View {
    let photo: ArchivePhoto?
    let height: CGFloat

    var body: some View {
        Group {
            if let photo, let url = URL(string: photo.url) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .accessibilityLabel(photo?.label ?? "Photographie indisponible")
    }

    private var placeholder: some View {
        ZStack {
            HeritagePalette.bordeaux.opacity(0.13)
            Image(systemName: "camera.metering.unknown")
                .font(.system(size: 26, weight: .ultraLight))
                .foregroundStyle(HeritagePalette.muted)
        }
    }
}

struct ArchiveCard: View {
    let entry: ArchiveEntry
    let exactToday: Bool
    let language: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    private var headline: String {
        entry.isQuote ? entry.originalTR :
            (language == "tr" ? entry.titleTR : entry.titleFR)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ArchivePhotoView(photo: ArchiveRepository.photo(for: entry), height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(entry.kind == "quote" ? "PAROLE D’ATATÜRK" : "REPÈRE HISTORIQUE")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(HeritagePalette.bordeaux)
            Text(headline)
                .font(.system(size: 25, design: .serif))
                .foregroundStyle(HeritagePalette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(entry.isQuote ? entry.translationFR : entry.contextFR)
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(HeritagePalette.muted)
            HStack {
                Text(ArchiveRepository.historicalDate(entry, language: language))
                    .font(.system(size: 11))
                    .foregroundStyle(HeritagePalette.muted)
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
                .accessibilityLabel(isFavorite ? "Retirer des favoris" : "Ajouter aux favoris")
            }
        }
        .padding(16)
        .background(HeritagePalette.paper, in: RoundedRectangle(cornerRadius: 17))
    }
}
