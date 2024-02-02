//
//  HomeView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI

struct HomeView: View {
    @Namespace var animation
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var currentStreakState: HomeViewModel.State {
        viewModel.streakStatus
    }
    
    var dayStreak: Int {
        viewModel.streakCount
    }
    
    var body: some View {
        NavigationStack {
            List {
                BannerSectionView()
                
                WarningBannerView(model: viewModel.warningBannerContent)
                
                StreakBoardView(model: viewModel.streakBoardContent)
                    .padding(.vertical)
                    .listRowSeparator(.hidden)
                
                Section {
                    CalendarView(records: $viewModel.flossRecords, style: .week)
                        .padding(.vertical, 7.5)
                }
                
                BannerSectionView()
            }
            .listSectionSpacing(25)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "plus")
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        LogRecordsView(viewModel: ContentViewModel())
                        
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .tint(Color.primary)
    }
}

#Preview {
    HomeView()
    
}
