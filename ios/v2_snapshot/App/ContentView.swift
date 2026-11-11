import SwiftUI

struct HeritageRootView: View {
    @AppStorage("heritage.language") private var language = "fr"
    @AppStorage("heritage.favorites") private var storedFavorites = ""
    @State private var selectedTab = 0
    private var favoriteIDs: Set<String> { Set(storedFavorites.split(separator: "|").map(String.init)) }

    var body: some View {
        TabView(selection: $selectedTab) {
            dailyView
                .tabItem { Label("Aujourd’hui", systemImage: "sun.max") }
                .tag(0)
            archiveView(onlyFavorites: false)
                .tabItem { Label("Explorer", systemImage: "square.grid.2x2") }
                .tag(1)
            ArchiveGalleryView()
                .tabItem { Label("Photographies", systemImage: "photo.on.rectangle") }
                .tag(3)
            archiveView(onlyFavorites: true)
                .tabItem { Label("Favoris", systemImage: "bookmark") }
                .tag(2)
        }
        .toolbarBackground(HeritagePalette.paper, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }

    private var dailyView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ATATÜRK").font(.system(size: 31, weight: .regular, design: .serif)).tracking(3)
                            Text("H E R I T A G E").font(.system(size: 9, weight: .medium)).tracking(3).foregroundStyle(HeritagePalette.gold)
                        }
                        Spacer()
                        Menu {
                            Button("Français") { language = "fr" }
                            Button("Türkçe") { language = "tr" }
                        } label: {
                            Label(language.uppercased(), systemImage: "globe")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .tint(HeritagePalette.ink)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(language == "fr" ? "UNE JOURNÉE, UNE HISTOIRE" : "HER GÜNE BİR TARİH")
                                .font(.system(size: 10, weight: .medium)).tracking(2)
                                .foregroundStyle(HeritagePalette.bordeaux)
                            Text(Date.now.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: language == "fr" ? "fr_FR" : "tr_TR"))))
                                .font(.system(size: 22, design: .serif))
                        }
                        Spacer()
                        Image(systemName: "star.circle").font(.system(size: 25, weight: .ultraLight)).foregroundStyle(HeritagePalette.gold)
                    }
                    let feed = ArchiveRepository.selectionFeed()
                    if !feed.isEmpty {
                        TodayPages(feed: feed, language: language, favorites: favoriteIDs, toggle: toggleFavorite)
                    } else {
                        ContentUnavailableView("Registre introuvable", systemImage: "books.vertical", description: Text("Vérifiez que entries.json est inclus dans les ressources de l’application."))
                    }
                    Text(language == "fr" ? "Les dates et les citations sont vérifiables depuis leur source. Si un jour n’est pas établi, il n’est jamais inventé." : "Kesin tarihi bilinmeyen sözler için gün uydurulmaz.")
                        .font(.system(size: 12, design: .serif)).foregroundStyle(HeritagePalette.muted)
                        .padding(.horizontal, 4)
                }
                .padding(.horizontal, 19)
                .padding(.top, 18)
                .padding(.bottom, 30)
            }
            .background(HeritagePalette.canvas)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func archiveView(onlyFavorites: Bool) -> some View {
        ArchiveListView(onlyFavorites: onlyFavorites, language: language,
                        favoriteIDs: favoriteIDs, toggleFavorite: toggleFavorite)
    }

    private func toggleFavorite(_ entry: ArchiveEntry) {
        var ids = favoriteIDs
        if ids.contains(entry.id) { ids.remove(entry.id) } else { ids.insert(entry.id) }
        storedFavorites = ids.sorted().joined(separator: "|")
    }
}

private struct TodayPages: View {
    let feed: [ArchiveEntry]
    let language: String
    let favorites: Set<String>
    let toggle: (ArchiveEntry) -> Void
    @State private var selected = 0

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(selected == 0 ? (ArchiveRepository.sameCalendarDay(feed[0], as: .now) ? "À LA DATE DU JOUR" : "À DÉCOUVRIR AUJOURD’HUI") : "DANS LES ARCHIVES")
                    .font(.system(size: 10, weight: .semibold)).tracking(1.5).foregroundStyle(HeritagePalette.muted)
                Spacer()
                Text("\(selected + 1) / \(feed.count)")
                    .font(.system(size: 12, weight: .regular, design: .monospaced)).foregroundStyle(HeritagePalette.muted)
            }
            TabView(selection: $selected) {
                ForEach(feed.indices, id: \.self) { index in
                    ScrollView {
                        ArchiveCard(entry: feed[index], exactToday: ArchiveRepository.sameCalendarDay(feed[index], as: .now),
                                    language: language, isFavorite: favorites.contains(feed[index].id),
                                    toggleFavorite: { toggle(feed[index]) })
                            .padding(.vertical, 3)
                    }
                    .scrollIndicators(.hidden)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 640)
            HStack(spacing: 6) {
                Image(systemName: "hand.draw")
                Text("Balayez vers la gauche ou la droite pour explorer")
            }
            .font(.system(size: 11)).foregroundStyle(HeritagePalette.muted)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ArchiveListView: View {
    let onlyFavorites: Bool
    let language: String
    let favoriteIDs: Set<String>
    let toggleFavorite: (ArchiveEntry) -> Void
    @State private var search = ""
    @State private var category = "Tous"
    @State private var quotesOnly = false

    private var filtered: [ArchiveEntry] {
        ArchiveRepository.entries
            .filter { !onlyFavorites || favoriteIDs.contains($0.id) }
            .filter { category == "Tous" || $0.theme == category }
            .filter { !quotesOnly || $0.isQuote }
            .filter {
                search.isEmpty || [ $0.originalTR, $0.translationFR, $0.titleFR, $0.titleTR, $0.contextFR, $0.theme ]
                    .joined(separator: " ").localizedCaseInsensitiveContains(search)
            }
            .sorted { ($0.date ?? "") > ($1.date ?? "") }
    }
    private var themes: [String] { ["Tous"] + Array(Set(ArchiveRepository.entries.map(\.theme))).sorted() }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Menu {
                        ForEach(themes, id: \.self) { theme in Button(theme) { category = theme } }
                    } label: {
                        Label(category, systemImage: "line.3.horizontal.decrease")
                    }
                    Toggle(isOn: $quotesOnly) {
                        Text("Citations uniquement")
                    }
                    .toggleStyle(.switch)
                    .font(.system(size: 11))
                    .scaleEffect(0.85, anchor: .trailing)
                }
                .font(.system(size: 12))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filtered) { item in
                            NavigationLink {
                                ArchiveDetailView(entry: item, language: language,
                                                  isFavorite: favoriteIDs.contains(item.id),
                                                  toggleFavorite: { toggleFavorite(item) })
                            } label: {
                                HStack(spacing: 14) {
                                    ArchivePhotoView(photo: ArchiveRepository.photo(for: item), height: 95)
                                        .frame(width: 86).clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text(item.kind == "quote" ? "CITATION · \(item.theme.uppercased())" : "HISTOIRE · \(item.theme.uppercased())")
                                            .font(.system(size: 9, weight: .semibold)).tracking(1).foregroundStyle(HeritagePalette.bordeaux)
                                        Text(item.isQuote ? item.originalTR : (language == "fr" ? item.titleFR : item.titleTR))
                                            .font(.system(size: 16, design: .serif))
                                            .lineLimit(3).multilineTextAlignment(.leading)
                                            .foregroundStyle(HeritagePalette.ink)
                                        Text(ArchiveRepository.historicalDate(item, language: language))
                                            .font(.system(size: 10)).foregroundStyle(HeritagePalette.muted)
                                    }
                                    Spacer(minLength: 0)
                                    Image(systemName: "chevron.right").font(.system(size: 10)).foregroundStyle(HeritagePalette.gold)
                                }
                                .padding(9)
                                .background(HeritagePalette.paper, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                        if filtered.isEmpty {
                            ContentUnavailableView(onlyFavorites ? "Aucun favori" : "Aucun résultat", systemImage: "text.book.closed")
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                }
            }
            .background(HeritagePalette.canvas)
            .navigationTitle(onlyFavorites ? "Mes favoris" : "Les archives")
            .searchable(text: $search, prompt: "Rechercher une citation ou une date")
        }
    }
}

private struct ArchiveDetailView: View {
    let entry: ArchiveEntry
    let language: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ArchiveCard(entry: entry, exactToday: ArchiveRepository.sameCalendarDay(entry, as: .now), language: language, isFavorite: isFavorite, toggleFavorite: toggleFavorite)
                Text("CONTEXTE & PROVENANCE")
                    .font(.system(size: 11, weight: .semibold)).tracking(1.6).foregroundStyle(HeritagePalette.bordeaux)
                Text(entry.contextFR)
                    .font(.system(size: 15, design: .serif)).foregroundStyle(HeritagePalette.ink)
                if let url = URL(string: entry.sourceURL) {
                    Link("Consulter le document historique ↗", destination: url)
                        .font(.system(size: 14, weight: .medium))
                }
                Text("L’original turc est conservé dans son écriture moderne de transcription. Les traductions françaises sont éditoriales. Les dates au jour près ne sont indiquées que lorsqu’elles sont documentées.")
                    .font(.system(size: 12)).foregroundStyle(HeritagePalette.muted)
            }
            .padding(16)
        }
        .background(HeritagePalette.canvas)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Galerie historique : aucune photographie générée artificiellement.
private struct ArchiveGalleryView: View {
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("PHOTOTHÈQUE HISTORIQUE")
                        .font(.system(size: 10, weight: .semibold)).tracking(2)
                        .foregroundStyle(HeritagePalette.bordeaux)
                    Text("Photographies d’époque, scans et documents historiques conservés dans des archives identifiées. Aucune image générée par IA.")
                        .font(.system(size: 14, design: .serif))
                        .foregroundStyle(HeritagePalette.muted)
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(ArchiveRepository.photos.sorted { ($0.originalWidth ?? 0) * ($0.originalHeight ?? 0) > ($1.originalWidth ?? 0) * ($1.originalHeight ?? 0) }) { photo in
                            NavigationLink {
                                ArchiveGalleryDetailView(photo: photo)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    ArchivePhotoView(photo: photo, height: 176)
                                        .clipShape(RoundedRectangle(cornerRadius: 9))
                                    Text(photo.label)
                                        .font(.system(size: 13, weight: .regular, design: .serif))
                                        .foregroundStyle(HeritagePalette.ink)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                    Text(photo.approxYear)
                                        .font(.system(size: 10))
                                        .foregroundStyle(HeritagePalette.muted)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(16)
            }
            .background(HeritagePalette.canvas)
            .navigationTitle("Photographies")
        }
    }
}

private struct ArchiveGalleryDetailView: View {
    let photo: ArchivePhoto
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 17) {
                ArchivePhotoView(photo: photo, height: 390)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                Text(photo.label)
                    .font(.system(size: 26, design: .serif))
                Text(photo.institution)
                    .font(.system(size: 14))
                HStack(spacing: 12) {
                    Label(photo.approxYear, systemImage: "calendar")
                    if let w = photo.originalWidth, let h = photo.originalHeight, w > 0, h > 0 {
                        Label("\(w) × \(h) px", systemImage: "aspectratio")
                    }
                }
                .font(.system(size: 11))
                .foregroundStyle(HeritagePalette.muted)
                Text("DROITS ET PROVENANCE")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(HeritagePalette.bordeaux)
                Text(photo.license)
                    .font(.system(size: 13, design: .serif))
                if let url = URL(string: photo.sourceUrl) {
                    Link("Voir la notice et les droits d’utilisation", destination: url)
                        .font(.system(size: 13, weight: .medium))
                }
                if let note = photo.note {
                    Text(note).font(.system(size: 12)).foregroundStyle(HeritagePalette.muted)
                }
                Text("La présence d’une photographie dans la galerie ne constitue pas une autorisation universelle de réutilisation commerciale. Vérifiez sa notice et la loi applicable.")
                    .font(.system(size: 12, design: .serif))
                    .foregroundStyle(HeritagePalette.muted)
            }
            .padding(18)
        }
        .background(HeritagePalette.canvas)
        .navigationTitle("Notice d’archive")
        .navigationBarTitleDisplayMode(.inline)
    }
}