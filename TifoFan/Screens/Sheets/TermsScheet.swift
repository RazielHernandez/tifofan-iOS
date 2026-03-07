//
//  TermsScheet.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-06.
//

import SwiftUI

struct TermsSheet: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    Text("Terms & Conditions")
                        .font(.largeTitle)
                        .bold()

                    Text("""
These Terms and Conditions govern your use of this application.

By using the app, you agree to comply with these terms.

1. The app is provided for informational and entertainment purposes.

2. Data shown in the app may come from third-party providers.

3. The developer is not responsible for inaccuracies in external data.

4. These terms may be updated at any time.
""")

                }
                .padding()

            }

            .navigationTitle("Terms")
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
