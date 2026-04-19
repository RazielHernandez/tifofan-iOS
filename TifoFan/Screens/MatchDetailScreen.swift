//
//  MatchDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum MatchTab: String, CaseIterable {
    case stats = "Stats"
    case lineups = "Lineups"
    case mxm = "MxM"
}

enum MatchPhase {
    case notStarted
    case live
    case halfTime
    case finished
    case unknown

    init(status: String) {
        switch status {
        case "NS": self = .notStarted
        case "1H", "2H": self = .live
        case "HT": self = .halfTime
        case "FT": self = .finished
        default: self = .unknown
        }
    }
}

struct MatchDetailScreen: View {
    
    let matchId: Int
    
    @StateObject private var vm = MatchViewModel()
    @State private var selectedTab: MatchTab = .stats
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            } else if let match = vm.selectedMatch {
                
                // LIVE MATCH BANNER
                if MatchPhase(status: match.status) == .live {
                    LiveMatchBanner()
                }
                
                // HEADER
                MatchHeaderView(match: match)
                
                // TAB BAR
                HStack {
                    ForEach(MatchTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            Text(tab.rawValue)
                                .foregroundColor(selectedTab == tab ? .white : .blue)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == tab ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // CONTENT
                ScrollView {
                    switch selectedTab {
                    case .stats:
                        StatsMatchView(stats: vm.statistics, match: match)
                    case .lineups:
                        LineupsView(matchId: matchId)
                    case .mxm:
                        MatchEventsScreen(matchId: matchId, match: match)
                    }
                }
            }
        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchMatchDetail(matchId: matchId)
            //await vm.fetchMatchStatistics(matchId: matchId)
        }
    }
}

struct LiveMatchBanner: View {
    var body: some View {
        HStack {
            Circle()
                .fill(.red)
                .frame(width: 8, height: 8)
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 0.8).repeatForever(), value: true)

            Text("LIVE MATCH")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Spacer()
        }
        .padding(10)
        .background(Color.red.opacity(0.08))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct MatchHeaderView: View {

    let match: MatchDetail

    var phase: MatchPhase {
        MatchPhase(status: match.status)
    }

    var body: some View {
        VStack(spacing: 12) {

            HStack {
                TeamBlock(team: match.home.team)

                Spacer()

                ScoreBlock(match: match)

                Spacer()

                TeamBlock(team: match.away.team)
            }

            statusBadge
        }
        .padding()
    }

    private var statusBadge: some View {
        HStack(spacing: 6) {

            if phase == .live {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.2)
                    .opacity(0.8)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: phase)

                Text("LIVE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)

            } else {

                Image(systemName: icon)
                    .font(.caption2)

                Text(text)
                    .font(.caption2)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.blue.opacity(0.08))
        .cornerRadius(8)
    }

    private var icon: String {
        switch phase {
        case .notStarted: return "clock"
        case .halfTime: return "pause.circle"
        case .finished: return "flag.checkered"
        default: return "info.circle"
        }
    }

    private var text: String {
        switch phase {
        case .notStarted: return "Not started"
        case .halfTime: return "Half time"
        case .finished: return "Finished"
        default: return match.status
        }
    }
}

struct TeamBlock: View {
    
    let team: TeamSummary
    
    var body: some View {
        VStack {
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            
            Text(team.name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
    }
}

struct ScoreBlock: View {

    let match: MatchDetail
    @State private var now = Date()

    var phase: MatchPhase {
        MatchPhase(status: match.status)
    }

    var body: some View {
        VStack(spacing: 6) {

            Text(scoreText)
                .font(.title)
                .bold()

            Text(subtitleText)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
                now = Date()
            }
        }
    }

    private var scoreText: String {
        "\(match.home.goals ?? 0) - \(match.away.goals ?? 0)"
    }

    private var subtitleText: String {

        switch phase {

        case .notStarted:
            let diff = Int(match.date.timeIntervalSince(now))
            let minutes = max(diff / 60, 0)
            return "Starts in \(minutes)m"

        case .live:
            return "LIVE • \(liveMinutes)'"

        case .halfTime:
            return "Half Time"

        case .finished:
            return "Full Time"

        default:
            return match.status
        }
    }

    private var liveMinutes: Int {
        let diff = Int(now.timeIntervalSince(match.date))
        return max(diff / 60, 1)
    }
}

struct OverviewView: View {
    
    let match: MatchDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Match Info")
                .font(.headline)
            
            HStack {
                Text("League")
                Spacer()
                Text(match.leagueId.description)
            }
            
            HStack {
                Text("Date")
                Spacer()
                Text(match.date, style: .date)
            }
            
            HStack {
                Text("Venue")
                Spacer()
                Text(match.venue ?? "N/A")
            }
        }
        .padding()
    }
}

struct StatsMatchView: View {
    
    let stats: [TeamMatchStatistics]
    let match: MatchDetail
    
//    var body: some View {
//        VStack(spacing: 12) {
//            
//            VStack(spacing: 12) {
//                HStack {
//                    Text("Date")
//                    Spacer()
//                    Text(match.date, style: .date)
//                }
//                
//                HStack {
//                    Text("Venue")
//                    Spacer()
//                    Text(match.venue ?? "N/A")
//                }
//            }
//            .padding()
//            .background(Color(.systemBackground))
//            .cornerRadius(12)
//            .shadow(radius: 2)
//            
//            
//            VStack(spacing:12) {
//                ForEach(statItems(), id: \.title) { item in
//                    StatBarRow(
//                        item: item,
//                    )
//                }
//            }
//            .padding()
//            .background(Color(.systemBackground))
//            .cornerRadius(12)
//            .shadow(radius: 2)
//            
//        }
//        .padding()
//    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MATCH INFO
            infoCard
            
            if stats.isEmpty {
                
                MatchEmptyState(
                    icon: "chart.bar.xaxis",
                    title: "No stats yet",
                    subtitle: "Statistics will appear once the match starts."
                )
                
//                VStack(spacing: 14) {
//                    
//                    Image(systemName: "chart.bar.xaxis")
//                        .font(.largeTitle)
//                        .foregroundColor(.gray)
//                    
//                    Text(match.status == "NS"
//                         ? "Match hasn't started"
//                         : "No statistics available")
//                        .font(.headline)
//                    
//                    Text(match.status == "NS"
//                         ? "Stats will appear once the game kicks off."
//                         : "Statistics are not available for this match.")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                .padding()
                
            } else {
                
                statsContent
            }
        }
        .padding()
    }
    
    private var infoCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Date")
                Spacer()
                Text(match.date, style: .date)
            }
            
            HStack {
                Text("Venue")
                Spacer()
                Text(match.venue ?? "N/A")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var statsContent: some View {
        VStack(spacing: 12) {
            ForEach(statItems(), id: \.title) { item in
                StatBarRow(item: item)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func statItems() -> [StatItemModel] {
        guard stats.count == 2 else { return [] }
        
        let home = stats[0].stats
        let away = stats[1].stats
        
        return [
            StatItemModel("Shots on Goal", home.shotsOnGoal ?? 0, away.shotsOnGoal ?? 0, icon: "scope"),
            StatItemModel("Total Shots", home.totalShots ?? 0, away.totalShots ?? 0, icon: "soccerball"),
            StatItemModel("Possession", home.possession ?? 0, away.possession ?? 0, icon: "chart.pie.fill", isPercentage: true),
            StatItemModel("Passes", home.passes ?? 0, away.passes ?? 0, icon: "arrow.left.arrow.right"),
            StatItemModel("Corners", home.corners ?? 0, away.corners ?? 0, icon: "flag.fill"),
            StatItemModel("Fouls", home.fouls ?? 0, away.fouls ?? 0, icon: "exclamationmark.triangle"),
            StatItemModel("Offsides", home.offsides ?? 0, away.offsides ?? 0, icon: "figure.run"),
            StatItemModel("Yellow Cards", home.yellowCards?.value ?? 0, away.yellowCards?.value ?? 0, icon: "square.fill"),
            StatItemModel("Red Cards", home.redCards?.value ?? 0, away.redCards?.value ?? 0, icon: "stop.fill")
        ]
    }
}

struct MatchEmptyState: View {

    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.gray)

            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
}

struct StatItemModel: Identifiable {
    let id = UUID()
    let title: String
    let home: Int
    let away: Int
    let icon: String
    let isPercentage: Bool
    
    init(_ title: String, _ home: Int, _ away: Int, icon: String, isPercentage: Bool = false) {
        self.title = title
        self.home = home
        self.away = away
        self.icon = icon
        self.isPercentage = isPercentage
    }
}

struct StatBarRow: View {
    
    let item: StatItemModel
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            // HEADER (values + icon + title)
            HStack {
                Text(displayValue(item.home))
                    .fontWeight(.semibold)
                    .foregroundColor(color(for: item.home, opponent: item.away))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: item.icon)
                        .font(.caption)
                    Text(item.title)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Text(displayValue(item.away))
                    .fontWeight(.semibold)
                    .foregroundColor(color(for: item.away, opponent: item.home))
            }
            
            // BAR
            GeometryReader { geo in
                let halfWidth = geo.size.width / 2
                
                ZStack {
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 2)
                    
                    // BACKGROUND TRACK (optional)
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                    
                    HStack(spacing: 0) {
                        
                        // HOME (LEFT SIDE)
                        HStack {
                            Spacer()
                            
                            Rectangle()
                                .fill(homeGradient)
                                .frame(
                                    width: animate
                                    ? barWidth(total: halfWidth, value: item.home)
                                    : 0
                                )
                        }
                        .frame(width: halfWidth)
                        
                        // AWAY (RIGHT SIDE)
                        HStack {
                            Rectangle()
                                .fill(awayGradient)
                                .frame(
                                    width: animate
                                    ? barWidth(total: halfWidth, value: item.away)
                                    : 0
                                )
                            
                            Spacer()
                        }
                        .frame(width: halfWidth)
                    }
                }
                .animation(.easeOut(duration: 0.8), value: animate)
            }
            .frame(height: 10)
        }
        .onAppear {
            animate = true
        }
    }
    
    // MARK: - Helpers
    
    private func displayValue(_ value: Int) -> String {
        item.isPercentage ? "\(value)%" : "\(value)"
    }
    
    private func barWidth(total: CGFloat, value: Int) -> CGFloat {
        if item.isPercentage {
            return total * CGFloat(value) / 100.0
        }
        
        let sum = max(item.home + item.away, 1)
        return total * CGFloat(value) / CGFloat(sum)
    }
    
    private func color(for value: Int, opponent: Int) -> Color {
        if value > opponent { return .green }
        if value < opponent { return .red }
        return .gray
    }
    
    // MARK: - Gradients
    
    private var homeGradient: LinearGradient {
        LinearGradient(
            colors: [Color.blue.opacity(0.7), Color.blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var awayGradient: LinearGradient {
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.7)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct LineupsView: View {
    
    let matchId: Int
    @StateObject private var vm = LineupViewModel()
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            }
            else if vm.lineups.isEmpty {
                
                MatchEmptyState(
                    icon: "person.3",
                    title: "Lineups not available",
                    subtitle: "Teams will be announced before kickoff."
                )
                
//                VStack(spacing: 14) {
//                    Image(systemName: "person.3")
//                        .font(.largeTitle)
//                        .foregroundColor(.gray)
//                    
//                    Text("Lineups not available")
//                        .font(.headline)
//                    
//                    Text("They will be announced shortly before kickoff.")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                .padding()
            } else if vm.lineups.count == 2 {
                
                ScrollView {
                    VStack(spacing: 16) {
                        FormationView(
                            home: vm.lineups[0],
                            away: vm.lineups[1]
                        )
                        
                        Divider().padding(.vertical)
                        
                        SubstitutesView(
                            homeSubs: vm.lineups[0].substitutes,
                            awaySubs: vm.lineups[1].substitutes
                        )
                    }
                    .padding(.bottom, 20)
                }
                
            }
        }
        .task {
            await vm.fetchLineups(matchId: matchId)
        }
    }
}

struct FormationView: View {
    
    let home: TeamLineup
    let away: TeamLineup
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Formation")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ZStack {
                
                // FIELD
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.8), Color.green.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack {
                    
                    // AWAY TEAM (top)
                    PlayersGrid(players: away.startXI, isHome: false)
                    
                    Spacer()
                    
                    Divider()
                        .background(Color.white)
                    
                    Spacer()
                    
                    // HOME TEAM (bottom)
                    PlayersGrid(players: home.startXI, isHome: true)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding()
    }
}

struct PlayersGrid: View {
    
    let players: [LineupPlayer]
    let isHome: Bool
    
    var grouped: [Int: [LineupPlayer]] {
        Dictionary(grouping: players) { player in
            Int(player.grid?.split(separator: ":").first ?? "0") ?? 0
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(grouped.keys.sorted(), id: \.self) { row in
                
                HStack(spacing: 12) {
                    ForEach(grouped[row] ?? []) { player in
                        PlayerView(player: player, isHome: isHome)
                    }
                }
            }
        }
    }
}

struct PlayerView: View {
    
    let player: LineupPlayer
    let isHome: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            
            Text("\(player.number ?? 0)")
                .font(.caption)
                .bold()
                .frame(width: 28, height: 28)
                .background(isHome ? Color.blue : Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            Text(shortName(player.name))
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
    
    private func shortName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count > 1 {
            return "\(parts.first!.prefix(1)). \(parts.last!)"
        }
        return name
    }
}

struct SubstitutesView: View {
    
    let homeSubs: [LineupPlayer]
    let awaySubs: [LineupPlayer]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Substitutes")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 12) {
                
                // HOME
                VStack(spacing: 8) {
                    ForEach(homeSubs) { player in
                        PlayerLineupRow(player: player, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // AWAY
                VStack(spacing: 8) {
                    ForEach(awaySubs) { player in
                        PlayerLineupRow(player: player, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )
            .padding(.horizontal)
        }
    }
}

struct PlayerLineupRow: View {
    
    let player: LineupPlayer
    let alignment: HorizontalAlignment
    
    var body: some View {
        HStack {
            
            if alignment == .leading {
                number
                name
                Spacer()
            } else {
                Spacer()
                name
                number
            }
        }
        .font(.subheadline)
    }
    
    private var number: some View {
        Text("\(player.number ?? 0)")
            .font(.caption)
            .fontWeight(.bold)
            .frame(width: 28, height: 28)
            .background(Color.blue.opacity(0.15))
            .clipShape(Circle())
    }
    
    private var name: some View {
        Text(player.name)
            .lineLimit(1)
    }
}
