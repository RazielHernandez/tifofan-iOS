//
//  PrivacyScheet.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-06.
//

import SwiftUI

struct PrivacySheet: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .bold()

                    Text("""
This app respects your privacy.

Information Collection
We do not collect personal data from users.

Usage Data
Basic anonymous analytics may be used to improve the app experience.

Third-Party Services
The app may use external APIs to retrieve sports data.

Contact
For privacy questions please contact the developer.
""")

                }
                .padding()

            }

            .navigationTitle("Privacy Policy")
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
