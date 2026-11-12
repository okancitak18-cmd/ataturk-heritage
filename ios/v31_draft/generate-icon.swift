import AppKit
import Foundation

// Reproducible native app icon based on the project's historic SVG monogram.
// Exported as a 1024-pixel opaque PNG on the macOS GitHub Actions runner.
let size = 1024
let icon = NSImage(size: NSSize(width: size, height: size))
icon.lockFocus()
NSColor(calibratedRed: 0.455, green: 0.176, blue: 0.235, alpha: 1).setFill()
NSRect(x: 0, y: 0, width: size, height: size).fill()
let outline = NSBezierPath(roundedRect: NSRect(x: 80, y: 80, width: 864, height: 864),
                           xRadius: 85, yRadius: 85)
outline.lineWidth = 11
NSColor(calibratedRed: 0.815, green: 0.705, blue: 0.535, alpha: 1).setStroke()
outline.stroke()
let font = NSFont(name: "TimesNewRomanPS-BoldMT", size: 665) ?? .boldSystemFont(ofSize: 665)
let text = "A" as NSString
let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor(calibratedRed: 0.975, green: 0.946, blue: 0.890, alpha: 1)
]
let dimensions = text.size(withAttributes: attributes)
text.draw(at: NSPoint(x: (CGFloat(size) - dimensions.width) / 2,
                      y: (CGFloat(size) - dimensions.height) / 2 - 4),
          withAttributes: attributes)
icon.unlockFocus()
guard let tiff = icon.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("Unable to rasterize the app icon")
}
let output = "App/Assets.xcassets/AppIcon.appiconset/icon-1024.png"
try FileManager.default.createDirectory(atPath: "App/Assets.xcassets/AppIcon.appiconset",
                                        withIntermediateDirectories: true)
try png.write(to: URL(fileURLWithPath: output))
print("Generated \(output): \(png.count) bytes")
