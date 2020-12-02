//
//  Airline.swift
//  Enroute
//
//  Created by Bogdan Orzea on 11/30/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import CoreData

extension Airline: Comparable {
    var code: String {
        get { code_! }
        set { code_ = newValue }
    }

    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue }
    }

    var shortname: String {
        get { shortname_ ?? "Unknown" }
        set { shortname_ = newValue }
    }

    var fligths: Set<Flight> {
        get { (flights_ as? Set<Flight>) ?? [] }
        set { flights_ = newValue as NSSet }
    }

    var friendlyName: String { shortname.isEmpty ? name : shortname }

    public static func < (lhs: Airline, rhs: Airline) -> Bool {
        lhs.name < rhs.name
    }
}

extension Airline {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airline>{
        let request = NSFetchRequest<Airline>(entityName: "Airline")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]

        return request
    }
}

extension Airline {
    static func withCode(_ code: String, context: NSManagedObjectContext) -> Airline {
        let request = fetchRequest(NSPredicate(format: "code_=%@", code))
        let results = (try? context.fetch(request)) ?? []
        if let airline = results.first {
            return airline
        } else {
            let airline = Airline(context: context)
            airline.code = code

            AirlineInfoRequest.fetch(code) { info in
                let airline = self.withCode(code, context: context)
                airline.name = info.name
                airline.shortname = info.shortname
                airline.objectWillChange.send()
                airline.fligths.forEach { $0.objectWillChange.send() }
                try? context.save()
            }

            return airline
        }
    }
}
