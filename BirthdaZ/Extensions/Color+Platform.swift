//
//  Color+Platform.swift
//  BirthdaZ
//
//  Cross-platform color helpers for iOS and macOS
//

import SwiftUI

extension Color {
    /// Adaptive label color - works on both iOS and macOS
    static var adaptiveLabel: Color {
        #if os(iOS)
        return Color(uiColor: .label)
        #elseif os(macOS)
        return Color(nsColor: .labelColor)
        #endif
    }

    /// Adaptive system background color - works on both iOS and macOS
    static var adaptiveSystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    /// Adaptive secondary system background color
    static var adaptiveSecondarySystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        return Color(nsColor: .controlBackgroundColor)
        #endif
    }

    /// Create Color from platform-specific semantic color
    static func platformColor(light: Color, dark: Color) -> Color {
        // This will automatically adapt based on color scheme
        return Color.primary
    }
}

// MARK: - Cross-platform Image Helper

/// Helper function to create SwiftUI Image from Data cross-platform
func imageFromData(_ data: Data) -> Image? {
    #if os(iOS)
    guard let uiImage = UIImage(data: data) else { return nil }
    return Image(uiImage: uiImage)
    #elseif os(macOS)
    guard let nsImage = NSImage(data: data) else { return nil }
    return Image(nsImage: nsImage)
    #endif
}

/// Cross-platform image compression helper
enum ImageCompressionHelper {
    /// Compress image data to fit within max dimension
    static func compress(_ data: Data, maxDimension: CGFloat = 800) -> Data? {
        #if os(iOS)
        guard let uiImage = UIImage(data: data) else { return nil }
        let resized = resizeImage(uiImage, maxDimension: maxDimension)
        return resized.jpegData(compressionQuality: 0.7)
        #elseif os(macOS)
        guard let nsImage = NSImage(data: data) else { return nil }
        let resized = resizeImage(nsImage, maxDimension: maxDimension)
        guard let tiffData = resized.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.7])
        #endif
    }

    #if os(iOS)
    private static func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = calculateNewSize(original: image.size, maxDimension: maxDimension)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? image
    }
    #elseif os(macOS)
    private static func resizeImage(_ image: NSImage, maxDimension: CGFloat) -> NSImage {
        let size = calculateNewSize(original: image.size, maxDimension: maxDimension)
        let resized = NSImage(size: size)
        resized.lockFocus()
        image.draw(in: CGRect(origin: .zero, size: size))
        resized.unlockFocus()
        return resized
    }
    #endif

    private static func calculateNewSize(original: CGSize, maxDimension: CGFloat) -> CGSize {
        let maxCurrentDimension = max(original.width, original.height)
        guard maxCurrentDimension > maxDimension else { return original }

        let ratio = maxDimension / maxCurrentDimension
        return CGSize(width: original.width * ratio, height: original.height * ratio)
    }
}