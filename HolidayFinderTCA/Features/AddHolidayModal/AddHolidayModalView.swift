//
//  AddHolidayModalView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

// AddHolidayModalView.swift
import SwiftUI
import ComposableArchitecture
import Foundation

struct AddHolidayModalView: View {
    let store: Store<AddHolidayModalState, AddHolidayModalAction>
    let initialStartDate: Date
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    Form {
                        VStack(alignment: .leading, spacing: 16) {
                            if viewStore.currentStep == 1 {
                                AirportSelectionStepView(store: store, isOrigin: true)
                            } else if viewStore.currentStep == 2 {
                                AirportSelectionStepView(store: store, isOrigin: false)
                            } else if viewStore.currentStep == 3 {
                                DateSelectionStepView(store: store, isStartDate: true)
                            } else if viewStore.currentStep == 4 {
                                DateSelectionStepView(store: store, isStartDate: false)
                            }
                        }
                        .padding(.vertical)
                        
                        if viewStore.currentStep < 4 {
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewStore.send(.nextStep)
                                }) {
                                    Text("Next")
                                        .padding(.horizontal)
                                }
                                .disabled(!isNextButtonEnabled)
                            }
                        } else {
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewStore.send(.saveVacation)
                                }) {
                                    Text("Save Vacation")
                                        .padding(.horizontal)
                                }
                                .disabled(!isNextButtonEnabled)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Add Holiday", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewStore.send(.previousStep)
                }) {
                    Text("Back")
                }
                    .disabled(viewStore.currentStep == 1),
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
            )
            .sheet(isPresented: viewStore.binding(
                get: \.showAirportSelection,
                send: { _ in AddHolidayModalAction.hideAirportSelection }
            )) {
                AirportSelectionSheet(store: store, isOrigin: viewStore.currentStep == 1)
            }
            .alert(item: viewStore.binding(
                get: \.saveStatus,
                send: AddHolidayModalAction.dismissSaveStatus
            )) { status in
                Alert(
                    title: Text(status == .success ? "Success" : "Error"),
                    message: Text(status == .success ? "Vacation saved successfully." : "Failed to save vacation."),
                    dismissButton: .default(Text("OK"), action: {
                        if status == .success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                )
            }
            .onAppear {
                viewStore.send(.onAppear(initialStartDate: initialStartDate))
            }
        }
    }
    
    private var isNextButtonEnabled: Bool {
        let viewStore = ViewStore(store)
        switch viewStore.currentStep {
        case 1:
            return !viewStore.originAirport.isEmpty
        case 2:
            return !viewStore.destinationAirport.isEmpty && viewStore.originAirport != viewStore.destinationAirport
        case 3, 4:
            return viewStore.endDate > viewStore.startDate
        default:
            return false
        }
    }
}
