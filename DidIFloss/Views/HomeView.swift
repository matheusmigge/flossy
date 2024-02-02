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
            .buttonStyle(.borderless)
            .overlay {
                if viewModel.showingCelebration {
                    CelebrationView(delegate: self.viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.plusButtonPressed()

                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        LogRecordsView()
                        
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        .sheet(item: $viewModel.sheetView, content: { sheet in
            switch sheet {
            case .welcomeSheet:
                OnboardingView()
            case .addLogSheet:
                AddLogView(delegate: self.viewModel)
            }
        })
        .onAppear {
            viewModel.viewDidApper()
        }
    }
}

#Preview {
    HomeView()
    
}
