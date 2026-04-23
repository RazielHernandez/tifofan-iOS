//
//  TifoGenerator.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import Foundation
import SwiftUI

final class TifoGenerator {
    
    func generate(from url: URL, rows: Int, cols: Int) async throws -> TifoGrid {
        
        let image = try await downloadImage(from: url)
        
        guard let cgImage = resizeImage(image, targetSize: CGSize(width: cols, height: rows)) else {
            throw NSError(domain: "ResizeError", code: 0)
        }
        
        let pixels = extractPixels(from: cgImage)
        
        var cells: [String] = []
        cells.reserveCapacity(rows * cols)
        
        for color in pixels {
            let quantized = quantize(color, levels: 6)
            let hex = toHex(quantized)
            cells.append(hex)
        }
        
        return TifoGrid(rows: rows, cols: cols, cells: cells)
    }
    
    func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageError", code: 0)
        }
        
        return image
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> CGImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized.cgImage
    }
    
    func extractPixels(from cgImage: CGImage) -> [UIColor] {
        let width = cgImage.width
        let height = cgImage.height
        
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        
        let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var colors: [UIColor] = []
        
        for i in stride(from: 0, to: pixels.count, by: 4) {
            let r = CGFloat(pixels[i]) / 255.0
            let g = CGFloat(pixels[i+1]) / 255.0
            let b = CGFloat(pixels[i+2]) / 255.0
            let a = CGFloat(pixels[i+3]) / 255.0
            
            colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
        }
        
        return colors
    }
    
    func toHex(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
    
    func quantize(_ color: UIColor, levels: Int = 8) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        func q(_ value: CGFloat) -> CGFloat {
            let step = CGFloat(255 / (levels - 1))
            return round(value * 255 / step) * step / 255
        }
        
        return UIColor(red: q(r), green: q(g), blue: q(b), alpha: 1)
    }
    
    func generateTifoGrid(
        from image: UIImage,
        rows: Int,
        cols: Int
    ) -> TifoGrid? {
        
        guard let cgImage = resizeImage(image, targetSize: CGSize(width: cols, height: rows)) else {
            return nil
        }
        
        let pixels = extractPixels(from: cgImage)
        
        var cells: [String] = []
        cells.reserveCapacity(rows * cols)
        
        for color in pixels {
            let quantized = quantize(color, levels: 6)
            let hex = toHex(quantized)
            cells.append(hex)
        }
        
        return TifoGrid(rows: rows, cols: cols, cells: cells)
    }
}
