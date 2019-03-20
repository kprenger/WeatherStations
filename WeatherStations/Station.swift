//
//  Station.swift
//  WeatherStations
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
    
    init?(coordinateArray: [Double]?) {
        guard let coordinateArray = coordinateArray, coordinateArray.count == 2 else { return nil }
        
        // The data source uses GeoJSON, which stores coordinates as [lon, lat]
        self.latitude = coordinateArray[1]
        self.longitude = coordinateArray[0]
    }
}

struct Station {
    let abbreviation: String
    let coordinates: Coordinates
    let dataUrl: URL
    let name: String
    let timezone: String
    
    init?(json: [String: Any]) {
        guard let geo = json["geometry"] as? [String: Any],
            let props = json["properties"] as? [String: Any],
            let abbreviation = props["stationIdentifier"] as? String,
            let coordinates = Coordinates(coordinateArray: geo["coordinates"] as? [Double]),
            let dataUrl = URL(string: json["id"] as? String ?? "bad url"),
            let name = props["name"] as? String,
            let timezone = props["timeZone"] as? String
            else { return nil }
        
        self.abbreviation = abbreviation
        self.coordinates = coordinates
        self.dataUrl = dataUrl
        self.name = name
        self.timezone = timezone
    }
}
