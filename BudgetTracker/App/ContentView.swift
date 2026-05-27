import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .accessibilityIdentifier("tab.dashboard")

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "list.bullet.rectangle")
            }
            .accessibilityIdentifier("tab.history")
        }
    }
}

#Preview {
    ContentView()
}
