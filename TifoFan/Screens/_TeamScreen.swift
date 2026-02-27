//
//  _TeamScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import SwiftUI

struct TeamScreen: View {
    
    @StateObject private var vm = TeamViewModel()
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            }
            else if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            else if let response = vm.response {
                Text(response.team.name)
                    .font(.title)
                
                if let logo = response.team.logo,
                   let url = URL(string: logo) {
                    AsyncImage(url: url)
                        .frame(width: 80, height: 80)
                }
            }
            
            else {
                Text("Nothing to show here.")
            }
            
            
        }
        .task {
            await vm.fetchTeam(teamId: 2286)
        }
    }
}

#Preview {
    TeamScreen()
}
