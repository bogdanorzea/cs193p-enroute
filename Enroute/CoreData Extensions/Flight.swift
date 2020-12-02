//
//  Flight.swift
//  Enroute
//
//  Created by Bogdan Orzea on 11/30/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import CoreData

extension Flight {
    var arrival: Date {
        get { arrival_ ?? Date(timeIntervalSinceReferenceDate: 0)}
        set { arrival_ = newValue }
    }

    var ident: String {
        get { ident_ ?? "Unknown" }
        set { ident_ = newValue }
    }

    var origin: Airport {
        get { origin_! }
        set { origin_ = newValue }
    }

    var destination: Airport {
        get { destination_! }
        set { destination_ = newValue }
    }

    var airline: Airline {
        get { airline_! }
        set { airline_ = newValue }
    }

    var number: Int {
        Int(String(ident).drop(while: { !$0.isNumber })) ?? 0
    }
}

extension Flight {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Flight>{
        let request = NSFetchRequest<Flight>(entityName: "Flight")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "arrival_", ascending: true)]

        return request
    }
}

extension Flight {
    @discardableResult
    static func update(from faflight: FAFlight, context: NSManagedObjectContext) -> Flight {
        let request = fetchRequest(NSPredicate(format: "ident_ = %@", faflight.ident))
        let results = (try? context.fetch(request)) ?? []
        let flight = results.first ?? Flight(context: context)

        flight.ident = faflight.ident
        flight.origin = Airport.withICAO(faflight.origin, context: context)
        flight.destination = Airport.withICAO(faflight.destination, context: context)
        flight.arrival = faflight.arrival
        flight.departure = faflight.departure
        flight.filed = faflight.filed
        flight.aircraft = faflight.aircraft
        flight.airline = Airline.withCode(faflight.airlineCode, context: context)
        flight.objectWillChange.send()

        return flight
    }
}
