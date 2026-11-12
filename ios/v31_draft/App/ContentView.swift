import SwiftUI

struct HeritageRootView: View {
    @AppStorage("heritage.language") private var language = "fr"
    @AppStorage("heritage.favorites") private var storedFavorites = ""
    @AppStorage("heritage.theme") private var theme = "heritage"
    @AppStorage("heritage.appearance") private var appearance = "auto"
    @Environment(\.colorScheme) private var systemScheme
    @State private var selectedTab = 0
    @State private var deepLinkedEntry: ArchiveEntry?
    @State private var detailsEntry: ArchiveEntry?
    @State private var showSettings = false

    private var dark: Bool { appearance == "dark" || (appearance == "auto" && systemScheme == .dark) }
    private var design: HeritageDesign { HeritageDesign(theme: theme, dark: dark) }
    private var favoriteIDs: Set<String> { Set(storedFavorites.split(separator: "|").map(String.init)) }

    var body: some View {
        TabView(selection: $selectedTab) {
            dailyView
                .tabItem { Label("Aujourd’hui", systemImage: "sun.max") }
                .tag(0)
            archiveView(onlyFavorites: false)
                .tabItem { Label("Archives", systemImage: "books.vertical") }
                .tag(1)
            ArchiveGalleryView()
                .tabItem { Label("Photos", systemImage: "photo.on.rectangle") }
                .tag(2)
            archiveView(onlyFavorites: true)
                .tabItem { Label("Favoris", systemImage: "bookmark") }
                .tag(3)
        }
        .environment(\.heritageDesign, design)
        .tint(design.accent)
        .foregroundStyle(design.ink)
        .preferredColorScheme(appearance == "auto" ? nil : (appearance == "dark" ? .dark : .light))
        .toolbarBackground(design.paper, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .onOpenURL { url in
            guard let id = HeritageDeepLink.entryID(from: url),
                  let entry = ArchiveRepository.entry(id: id) else { return }
            HeritageSharedState.selectOnAppOpen(id)
            deepLinkedEntry = entry
        }
        .sheet(item: $deepLinkedEntry) { entry in
            detailSheet(entry)
        }
        .sheet(item: $detailsEntry) { entry in
            detailSheet(entry)
        }
        .sheet(isPresented: $showSettings) {
            HeritageSettingsView(theme: $theme, appearance: $appearance, language: $language)
                .environment(\.heritageDesign, design)
                .presentationDragIndicator(.visible)
        }
    }

    private func detailSheet(_ entry: ArchiveEntry) -> some View {
        NavigationStack {
            ArchiveDetailView(entry: entry, language: language,
                              isFavorite: favoriteIDs.contains(entry.id),
                              toggleFavorite: { toggleFavorite(entry) })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Fermer") {
                            deepLinkedEntry = nil
                            detailsEntry = nil
                        }
                        .foregroundStyle(design.accent)
                    }
                }
        }
        .environment(\.heritageDesign, design)
    }

    private var dailyView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ATATÜRK")
                                .font(.system(size: 31, weight: .regular, design: .serif))
                                .tracking(2)
                                .foregroundStyle(design.ink)
                            Text("H E R I T A G E")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(2.5)
                                .foregroundStyle(design.gold)
                        }
                        Spacer()
                        Button { showSettings = true } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 18))
                                .frame(width: 44, height: 44)
                                .background(design.paper, in: Circle())
                        }
                        .accessibilityLabel("Réglages")
                    }
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(language == "tr" ? "HER GÜNE BİR TARİH" : "UNE JOURNÉE, UNE HISTOIRE")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1.4)
                                .foregroundStyle(design.accent)
                            Text(Date.now.formatted(.dateTime.day().month(.wide).year()
                                .locale(Locale(identifier: language == "tr" ? "tr_TR" : "fr_FR"))))
                                .font(.system(size: 21, weight: .semibold, design: .serif))
                                .foregroundStyle(design.ink)
                        }
                        Spacer()
                        Image(systemName: "sun.max")
                            .foregroundStyle(design.gold)
                    }
                    let feed = ArchiveRepository.selectionFeed()
                    if !feed.isEmpty {
                        TodayPages(feed: feed, language: language,
                                   favorites: favoriteIDs, toggle: toggleFavorite,
                                   openContext: { detailsEntry = $0 })
                    } else {
                        ContentUnavailableView("Registre introuvable", systemImage: "books.vertical",
                            description: Text("La ressource entries_v2.json est absente."))
                    }
                    Text("Les sources et droits des documents historiques sont en cours de vérification.")
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(design.muted)
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
            .background(design.canvas.ignoresSafeArea())
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

private struct HeritageSettingsView: View {
    @Binding var theme: String
    @Binding var appearance: String
    @Binding var language: String
    @Environment(\.heritageDesign) private var design
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Thème") {
                    Picker("Univers graphique", selection: $theme) {
                        Text("Heritage").tag("heritage")
                        Text("Republic").tag("republic")
                        Text("Archive").tag("archive")
                    }
                    .pickerStyle(.segmented)
                }
                Section("Apparence") {
                    Picker("Affichage", selection: $appearance) {
                        Text("Auto").tag("auto")
                        Text("Clair").tag("light")
                        Text("Sombre").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }
                Section("Langue") {
                    Picker("Langue de lecture", selection: $language) {
                        Text("Français").tag("fr")
                        Text("Türkçe").tag("tr")
                    }
                }
                Section {
                    Text("Les images et attributions historiques sont encore en cours de vérification. Les fichiers textuels sont disponibles sans connexion.")
                        .font(.footnote)
                }
            }
            .scrollContentBackground(.hidden)
            .background(design.canvas)
            .foregroundStyle(design.ink)
            .navigationTitle("Réglages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Terminé") { dismiss() }
                }
            }
        }
    }
}

private struct TodayPages: View {
    let feed: [ArchiveEntry]
    let language: String
    let favorites: Set<String>
    let toggle: (ArchiveEntry) -> Void
    let openContext: (ArchiveEntry) -> Void
    @Environment(\.heritageDesign) private var design
    @State private var selected = 0

    private var current: ArchiveEntry { feed[min(max(0, selected), feed.count - 1)] }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(selected == 0 && ArchiveRepository.sameCalendarDay(current, as: .now)
                     ? "À LA DATE DU JOUR" : "DANS LES ARCHIVES")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.3)
                Spacer()
                Text("\(selected + 1) / \(feed.count)")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
            }
            .foregroundStyle(design.muted)
            ArchiveCard(entry: current,
                        exactToday: ArchiveRepository.sameCalendarDay(current, as: .now),
                        language: language,
                        isFavorite: favorites.contains(current.id),
                        toggleFavorite: { toggle(current) },
                        showContext: { openContext(current) })
                .id(current.id)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 70).onEnded { value in
                        if value.translation.height < -85 &&
                           abs(value.translation.height) > abs(value.translation.width) * 1.3 {
                            openContext(current)
                        } else if abs(value.translation.width) > 85 &&
                                  abs(value.translation.width) > abs(value.translation.height) * 1.3 {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                selected = (selected + (value.translation.width < 0 ? 1 : feed.count - 1)) % feed.count
                            }
                        }
                    }
                )
            HStack(spacing: 8) {
                Image(systemName: "hand.draw")
                Text("Balayer latéralement · Vers le haut pour comprendre")
            }
            .font(.system(size: 11))
            .foregroundStyle(design.muted)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ArchiveListView: View {
    let onlyFavorites: Bool
    let language: String
    let favoriteIDs: Set<String>
    let toggleFavorite: (ArchiveEntry) -> Void
    @Environment(\.heritageDesign) private var design
    @State private var search = ""
    @State private var category = "Tous"
    @State private var quotesOnly = false

    private var filtered: [ArchiveEntry] {
        ArchiveRepository.entries
            .filter { !onlyFavorites || favoriteIDs.contains($0.id) }
            .filter { category == "Tous" || $0.theme == category }
            .filter { !quotesOnly || $0.isQuote }
            .filter {
                search.isEmpty || [$0.originalTR, $0.translationFR, $0.titleFR, $0.titleTR,
                                   $0.contextFR, $0.theme, $0.date ?? ""]
                    .joined(separator: " ").localizedCaseInsensitiveContains(search)
            }
            .sorted { ($0.date ?? "") > ($1.date ?? "") }
    }

    private var themes: [String] { ["Tous"] + Array(Set(ArchiveRepository.entries.map(\.theme))).sorted() }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Menu {
                        ForEach(themes, id: \.self) { theme in
                            Button(theme) { category = theme }
                        }
                    } label: {
                        Label(category, systemImage: "line.3.horizontal.decrease")
                            .foregroundStyle(design.accent)
                    }
                    Spacer()
                    Toggle("Citations uniquement", isOn: $quotesOnly)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(design.ink)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filtered) { item in
                            NavigationLink {
                                ArchiveDetailView(entry: item, language: language,
                                    isFavorite: favoriteIDs.contains(item.id),
                                    toggleFavorite: { toggleFavorite(item) })
                            } label: {
                                HStack(spacing: 12) {
                                    ArchivePhotoView(photo: ArchiveRepository.photo(for: item), height: 86)
                                        .frame(width: 86)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.kind == "quote" ? "CITATION · \(item.theme.uppercased())" :
                                             "HISTOIRE · \(item.theme.uppercased())")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundStyle(design.accent)
                                        Text(item.isQuote ? (language == "tr" ? item.originalTR : item.translationFR) :
                                             (language == "tr" ? item.titleTR : item.titleFR))
                                            .font(.system(size: 16, design: .serif))
                                            .foregroundStyle(design.ink)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(3)
                                        Text(ArchiveRepository.historicalDate(item, language: language))
                                            .font(.system(size: 11))
                                            .foregroundStyle(design.muted)
                                    }
                                    Spacer(minLength: 0)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(design.gold)
                                }
                                .padding(10)
                                .background(design.paper, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                        if filtered.isEmpty {
                            ContentUnavailableView(onlyFavorites ? "Aucun favori" : "Aucun résultat",
                                                   systemImage: "text.book.closed")
                                .foregroundStyle(design.ink)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
            .background(design.canvas.ignoresSafeArea())
            .navigationTitle(onlyFavorites ? "Favoris" : "Archives")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $search, prompt: "Rechercher dans les archives")
        }
    }
}

private struct ArchiveDetailView: View {
    let entry: ArchiveEntry
    let language: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    @Environment(\.heritageDesign) private var design

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArchiveCard(entry: entry, exactToday: ArchiveRepository.sameCalendarDay(entry, as: .now),
                            language: language, isFavorite: isFavorite,
                            toggleFavorite: toggleFavorite)
                Text("CONTEXTE & PROVENANCE")
                    .font(.system(size: 11, weight: .bold)).tracking(1.4)
                    .foregroundStyle(design.accent)
                Text(language == "tr" && !entry.contextTR.isEmpty ? entry.contextTR : entry.contextFR)
                    .font(.system(size: 15, design: .serif))
                    .foregroundStyle(design.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Source déclarée : \(entry.sourceTitle)")
                    .font(.system(size: 12))
                    .foregroundStyle(design.muted)
                if let url = URL(string: entry.sourceURL), url.scheme == "https" {
                    Link("Consulter la source", destination: url).font(.subheadline)
                }
                Text("L'attribution, la datation et les conditions de réutilisation doivent encore être vérifiées.")
                    .font(.footnote).foregroundStyle(design.muted)
            }
            .padding(16)
        }
        .background(design.canvas.ignoresSafeArea())
        .navigationTitle("Comprendre")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ArchiveGalleryView: View {
    @Environment(\.heritageDesign) private var design
    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]
    @State private var selectedPhoto: ArchivePhoto?

    private var ordered: [ArchivePhoto] {
        ArchiveRepository.photos.sorted { $0.id < $1.id }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("24 documents photographiques · Sources et droits en cours d'audit")
                        .font(.subheadline)
                        .foregroundStyle(design.muted)
                    LazyVGrid(columns: columns, alignment: .center, spacing: 14) {
                        ForEach(ordered) { photo in
                            Button { selectedPhoto = photo } label: {
                                VStack(alignment: .leading, spacing: 9) {
                                    ArchivePhotoView(photo: photo, height: 168)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Text(photo.label)
                                        .font(.system(size: 13, weight: .medium, design: .serif))
                                        .foregroundStyle(design.ink)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(photo.approxYear)
                                        .font(.caption2)
                                        .foregroundStyle(design.muted)
                                }
                                .padding(9)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .background(design.paper, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(16)
            }
            .background(design.canvas.ignoresSafeArea())
            .navigationTitle("Photothèque")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedPhoto) { photo in
                ArchiveGalleryDetailView(photo: photo,
                    collection: ordered, onClose: { selectedPhoto = nil })
                    .environment(\.heritageDesign, design)
            }
        }
    }
}

private struct ArchiveGalleryDetailView: View {
    let photo: ArchivePhoto
    let collection: [ArchivePhoto]
    let onClose: () -> Void
    @Environment(\.heritageDesign) private var design
    @State private var current: ArchivePhoto?
    @State private var showingInfo = false
    @State private var zoom: CGFloat = 1
    @State private var dragScale: CGFloat = 1

    private var shown: ArchivePhoto { current ?? photo }
    private var index: Int { collection.firstIndex(where: { $0.id == shown.id }) ?? 0 }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("\(index + 1) / \(collection.count)")
                        .font(.footnote.monospacedDigit())
                    Spacer()
                    Button { showingInfo = true } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 21))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Informations sur la photographie")
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Fermer")
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                GeometryReader { proxy in
                    ArchivePhotoView(photo: shown, height: proxy.size.height)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaleEffect(zoom * dragScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { dragScale = $0 }
                                .onEnded { zoom = min(3.5, max(1, zoom * $0)); dragScale = 1 }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                zoom = zoom == 1 ? 2 : 1
                            }
                        }
                        .clipped()
                        .contentShape(Rectangle())
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 80).onEnded { val in
                                if zoom > 1.05 { return }
                                if val.translation.height > 110 &&
                                   abs(val.translation.height) > abs(val.translation.width) * 1.4 {
                                    onClose()
                                } else if abs(val.translation.width) > 85 &&
                                          abs(val.translation.width) > abs(val.translation.height) * 1.3 {
                                    move(val.translation.width < 0 ? 1 : -1)
                                }
                            }
                        )
                }
                HStack {
                    Button { move(-1) } label: {
                        Label("Précédent", systemImage: "chevron.left")
                    }
                    Spacer()
                    Button { move(1) } label: {
                        Label("Suivant", systemImage: "chevron.right")
                    }
                }
                .font(.subheadline)
                .tint(.white)
                .padding(20)
                Text(shown.label)
                    .font(.system(size: 15, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 22)
            }
        }
        .onAppear { current = photo }
        .sheet(isPresented: $showingInfo) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(shown.label)
                            .font(.system(size: 24, design: .serif))
                        Text(shown.institution).font(.subheadline)
                        Text("Datation déclarée : \(shown.approxYear)")
                        Text("Licence déclarée (non vérifiée) : \(shown.license)")
                        if let url = URL(string: shown.sourceUrl), url.scheme == "https" {
                            Link("Consulter la notice originale", destination: url)
                        }
                        if let note = shown.note { Text(note) }
                        Text("L'identification historique et le droit de redistribution n'ont pas encore été validés.")
                            .font(.footnote)
                    }
                    .foregroundStyle(design.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(22)
                }
                .background(design.canvas)
                .navigationTitle("Notice d'archive")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Fermer") { showingInfo = false }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    private func move(_ offset: Int) {
        guard !collection.isEmpty else { return }
        current = collection[(index + offset + collection.count) % collection.count]
        zoom = 1
        dragScale = 1
    }
}
