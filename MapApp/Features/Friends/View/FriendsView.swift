import SwiftUI

struct FriendsView: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                AppBottomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea()
        }
    }
}
