//
//  TeamLogoView.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-29.
//

import SwiftUI

struct TeamLogoView: View {
    let url: URL?
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            Color.gray.opacity(0.2)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
