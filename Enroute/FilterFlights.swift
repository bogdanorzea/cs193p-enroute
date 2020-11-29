//
//  FilterFlights.swift
//  Enroute
//
//  Created by Bogdan Orzea on 11/28/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @ObservedObject var allAirports = Airports.all
    @ObservedObject var allAirlines = Airlines.all

    @Binding var filterSearch: FlightSearch
    @Binding var isPresented: Bool

    @State private var draft: FlightSearch

    init(filterSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _filterSearch = filterSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: filterSearch.wrappedValue)
    }

    var body: some View {
        NavigationView {
            Form {
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
                        Text(allAirports[airport]?.friendlyName ?? airport ?? "Unknown").tag(airport)
                    }
                }
                Picker("Destination", selection: $draft.destination) {
                    ForEach(allAirports.codes, id: \.self) { airport in
                        Text(allAirports[airport]?.friendlyName ?? airport).tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirlines.codes, id: \.self) { (airline: String?) in
                        Text(allAirlines[airline]?.friendlyName ?? airline ?? "Unknown").tag(airline)
                    }
                }
                Toggle(isOn: $draft.inTheAir) {
                    Text("Enroute only")
                }
            }
                .navigationBarTitle("Filter flights")
                .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }

    private var doneButton: some View {
        Button("Done") {
            self.filterSearch = self.draft
            self.isPresented = false
        }
    }
}

