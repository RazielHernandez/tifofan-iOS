//
//  TifoView.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-23.
//

import SwiftUI

struct TifoView: View {
    
    let grid: TifoGrid?
    
    var body: some View {
        ZStack {
            
            if let grid {
                TifoPreviewGrid(grid: grid)
            } else {
                Image(systemName: "square.grid.3x3.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.4))
                    .padding(40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
    }
}

struct TifoPreviewGrid: View {
    
    let grid: TifoGrid
    
    var body: some View {
        GeometryReader { geo in
            
            let spacing: CGFloat = 0.5
            let totalSpacing = spacing * CGFloat(grid.cols - 1)
            let cellSize = (geo.size.width - totalSpacing) / CGFloat(grid.cols)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.fixed(cellSize), spacing: spacing),
                    count: grid.cols
                ),
                spacing: spacing
            ) {
                ForEach(grid.cells.indices, id: \.self) { index in
                    Rectangle()
                        .fill(
                            grid.cells[index] == "clear"
                            ? Color.clear
                            : Color(hex: grid.cells[index])
                        )
                        .frame(width: cellSize, height: cellSize)
                }
            }
        }
        .aspectRatio(CGFloat(grid.cols) / CGFloat(grid.rows), contentMode: .fit)
        .clipped()
    }
}
