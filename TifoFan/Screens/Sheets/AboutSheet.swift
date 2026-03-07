//
//  AboutAppSheet.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-06.
//

import SwiftUI

struct AboutSheet: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    Text("TifoFan")
                        .font(.largeTitle)
                        .bold()

                    Text("TifoFan is a demo football companion app that lets users explore leagues, matches, teams, and players.")

                    Text("Features")
                        .font(.headline)

                    Text("• Browse football leagues\n• Explore teams and players\n• View match details\n• Stay updated with football data")

                    Text("Developer")
                        .font(.headline)

                    Text("Carlos Hernandez")

                }
                .padding()
            }

            .navigationTitle("About")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }

            }
        }
    }
}
