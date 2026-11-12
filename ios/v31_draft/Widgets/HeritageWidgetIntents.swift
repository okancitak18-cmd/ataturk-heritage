import AppIntents
import WidgetKit

// Requires iOS 17+, and app + widget target membership for these intents.
// These App Intents must be built and tested on a physical device.
struct HeritageNextEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Référence suivante"
    static var description = IntentDescription("Avance à la référence historique suivante du widget.")
    static var openAppWhenRun = false
    func perform() async throws -> some IntentResult {
        _ = HeritageSharedState.move(1)
        return .result()
    }
}

struct HeritagePreviousEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Référence précédente"
    static var description = IntentDescription("Revient à la référence historique précédente du widget.")
    static var openAppWhenRun = false
    func perform() async throws -> some IntentResult {
        _ = HeritageSharedState.move(-1)
        return .result()
    }
}
