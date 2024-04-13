//
//  RootView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// RootView.swift
import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    var body: some View {
        WithViewStore(store) { viewStore in

                TabView(selection: viewStore.binding(
                    get: \.activeTab,
                    send: RootAction.setActiveTab
                )) {
                    NavigationView {
                        HolidaySearchView(
                            store: store.scope(
                                state: \.holidaySearch,
                                action: RootAction.holidaySearch
                            )
                        )
                    }
                    .tag(ActiveTab.holidaySearch)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .navigationViewStyle(.stack)
                    NavigationView {
                        MyVacationsView(
                            store: store.scope(
                                state: \.myVacations,
                                action: RootAction.myVacations
                            )
                        )
                    }
                    .tag(ActiveTab.myVacations)
                    .tabItem {
                        Image(systemName: "suitcase.fill")
                        Text("Vacations")
                    }
                    .navigationViewStyle(.stack)
                    NavigationView {
                        MyFlightsView(
                            store: store.scope(
                                state: \.myFlights,
                                action: RootAction.myFlights
                            )
                        )

                    }
                    .navigationViewStyle(.stack)
                    .tag(ActiveTab.myFlights)
                    .tabItem {
                        Image(systemName: "airplane")
                        Text("Flights")
                    }
                }
            
            
        }
    }
}

