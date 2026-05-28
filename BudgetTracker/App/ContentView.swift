import SwiftUI

struct ContentView: View {
    private enum Tab: Hashable {
        case dashboard
        case history
    }
    
    @State private var selectedTab: Tab = .dashboard
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView {
                    selectedTab = .history
                }
            }
            .tag(Tab.dashboard)
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .accessibilityIdentifier("tab.dashboard")

            NavigationStack {
                HistoryView()
            }
            .tag(Tab.history)
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
