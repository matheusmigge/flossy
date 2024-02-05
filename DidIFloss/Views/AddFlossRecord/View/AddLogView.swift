//
//  addLogView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 31/01/24.
//

import SwiftUI


struct AddLogView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var selectedDate: Date = .now
    
    weak var delegate: AddLogDelegate?
    
    var isSelectedDateValid: Bool {
        selectedDate < .now
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    
                    DatePicker("datePicker", selection: $selectedDate)
                        .datePickerStyle(.graphical)
                        .tint(.greenyBlue)
                    
                
                    
                    Button {
                        delegate?.addLogRecord(date: self.selectedDate)
                        
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
                            
                    }
                    .disabled(!isSelectedDateValid)
                    .opacity(isSelectedDateValid ? 1 : 0.75)
                    .overlay {
                        if !isSelectedDateValid {
                            Text("You may not add records in the future ")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .offset(y: -50)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Text("Dismiss")
//                        }
//                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            delegate?.addLogRecord(date: self.selectedDate)
                        } label: {
                            Text("Add")
                                .bold()
                        }
                        .disabled(!isSelectedDateValid)
                    }
                }
     
            }
        }
        .presentationDetents([.fraction(0.75), .large])
        .presentationCornerRadius(25)
        .presentationBackground(Material.regular)
    }

}

#Preview {
    AddLogView()
}
