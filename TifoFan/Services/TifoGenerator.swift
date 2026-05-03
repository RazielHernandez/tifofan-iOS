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
        
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "CGImageError", code: 0)
        }
        
        let pixels = sampleGrid(from: cgImage, rows: rows, cols: cols)
        
        let cells = pixels.map { color -> String in
            
            var alpha: CGFloat = 0
            color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            
            if alpha < 0.1 {
                return "clear"
            }
            
            let quantized = quantize(color, levels: 12)
            return toHex(quantized)
        }
        
        return TifoGrid(rows: rows, cols: cols, cells: cells)
    }
    
    func sampleGrid(from cgImage: CGImage, rows: Int, cols: Int) -> [UIColor] {
        
        let width = cgImage.width
        let height = cgImage.height
        
//        let cellWidth = width / cols
//        let cellHeight = height / rows
        let cellWidth = CGFloat(width) / CGFloat(cols)
        let cellHeight = CGFloat(height) / CGFloat(rows)
        
        guard let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data else {
            return []
        }
        
        let ptr = CFDataGetBytePtr(data)!
        
        var colors: [UIColor] = []
        colors.reserveCapacity(rows * cols)
        
        for row in 0..<rows {
            for col in 0..<cols {
                
                
                let x = Int((CGFloat(col) + 0.5) * cellWidth)
                let y = Int((CGFloat(row) + 0.5) * cellHeight)
                
                
                let bytesPerRow = cgImage.bytesPerRow
                let index = y * bytesPerRow + x * 4
                
                let r = CGFloat(ptr[index]) / 255.0
                let g = CGFloat(ptr[index + 1]) / 255.0
                let b = CGFloat(ptr[index + 2]) / 255.0
                let a = CGFloat(ptr[index + 3]) / 255.0
                
                if a < 0.1 {
                    colors.append(.clear)
                } else {
                    colors.append(UIColor(red: r, green: g, blue: b, alpha: 1))
                }
            }
        }
        
        return colors
    }
    
    func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageError", code: 0)
        }
        
        return image
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> CGImage? {
        
        let aspectWidth = targetSize.width / image.size.width
        let aspectHeight = targetSize.height / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let newSize = CGSize(
            width: image.size.width * aspectRatio,
            height: image.size.height * aspectRatio
        )
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let resized = renderer.image { _ in
            UIColor.clear.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: targetSize)).fill()
            
            let origin = CGPoint(
                x: (targetSize.width - newSize.width) / 2,
                y: (targetSize.height - newSize.height) / 2
            )
            
            image.draw(in: CGRect(origin: origin, size: newSize))
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
            
            if a < 0.1 {
                colors.append(.clear)
                continue
            }
            
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
            let quantized = quantize(color, levels: 10)
            let hex = toHex(quantized)
            cells.append(hex)
        }
        
        return TifoGrid(rows: rows, cols: cols, cells: cells)
    }
}
