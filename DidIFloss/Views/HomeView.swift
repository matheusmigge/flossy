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
    

    var body: some View {
        NavigationStack {
            List {
                BannerSectionView()
                
                WarningBannerView(model: viewModel.streakBoardViewModel.warmingBoardContent)
                
                StreakBoardView(model: viewModel.streakBoardViewModel.streakBoardContent)
                    .padding(.vertical)
                    .listRowSeparator(.hidden)
                    .onTapGesture(count: 3, perform: {
                        viewModel.goToDeveloperView()
                    })
              
                
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
                    .disabled(viewModel.showingCelebration)
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
                    .onDisappear {
                        viewModel.onboardingOver()
                    }
            case .addLogSheet:
                AddLogView(delegate: self.viewModel)
                
            case .developerSheet:
                DeveloperView()
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
