//
//  addLogView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 31/01/24.
//

import SwiftUI

struct addLogView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var selectedDate: Date = .now
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    
                    DatePicker("datePicker", selection: $selectedDate)
                        .datePickerStyle(.graphical)
                        .tint(.greenyBlue)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.greenyBlue)
                            }
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            
                        } label: {
                            Text("Dismiss")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("Done")
                                .bold()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    addLogView()
}
