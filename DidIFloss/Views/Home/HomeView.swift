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
                    .listRowSeparator(.hidden)
                
                HStack {
                    Spacer()
                    
                    StreakBoardView(model: viewModel.streakBoardViewModel.streakBoardContent)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .listRowSeparator(.hidden)
                        .onTapGesture(count: 3, perform: {
                            viewModel.goToDeveloperView()
                        })
                    
                    Spacer()
                }
                
                Section {
                    CalendarView(records: $viewModel.flossRecords, style: .week, delegate: viewModel)
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
//                        viewModel.plusButtonPressed()
                        viewModel.presentShareSheet()

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
        .alert("Would you like to remove all records for this day?", isPresented: $viewModel.showingAlert, actions: {
            Button("Remove Records", role: .destructive) {
                viewModel.removeRecordsForFocusedDate()
            }
            
            Button("Cancel", role: .cancel) {
                viewModel.alertDismiss()
            }
      
        })
        .sheet(item: $viewModel.sheetView, content: { sheet in
            switch sheet {
            case .welcomeSheet:
                OnboardingView()
                    .onDisappear {
                        viewModel.onboardingOver()
                    }
            case .addLogSheet:
                AddLogView(delegate: self.viewModel)
                
            case .shareStreak(let message):
                ShareStreakView(streakDescription: message)
                    .presentationDetents([.medium])
                
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
