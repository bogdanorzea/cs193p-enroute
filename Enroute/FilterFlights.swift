//
//  FilterFlights.swift
//  Enroute
//
//  Created by Bogdan Orzea on 11/28/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>

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
                Picker("Destination", selection: $draft.destination) {
                    ForEach(airports.sorted(), id: \.self) { airport in
                        Text(airport.friendlyName).tag(airport)
                    }
                }
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(Airport?.none)
                    ForEach(airports.sorted(), id: \.self) { (airport: Airport?) in
                        Text(airport?.friendlyName ?? "Unknown").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(Airline?.none)
                    ForEach(airlines.sorted(), id: \.self) { (airline: Airline?) in
                        Text(airline?.friendlyName ?? "Unknown").tag(airline)
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
            if draft.destination != self.filterSearch.destination {
                self.draft.destination.fetchIncomingFlights()
            }
            self.filterSearch = self.draft
            self.isPresented = false
        }
    }
}

