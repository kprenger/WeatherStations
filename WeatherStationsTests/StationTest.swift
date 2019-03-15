//
//  StationTest.swift
//  WeatherStationsTests
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import XCTest
@testable import WeatherStations

class StationTest: XCTestCase {

    let goodJson: [String: Any] = [
        "id": "https://api.weather.gov/stations/KRXE",
        "type": "Feature",
        "geometry": [
            "type": "Point",
            "coordinates": [
                -111.80611,
                43.83167
            ]
        ],
        "properties": [
            "@id": "https://api.weather.gov/stations/KRXE",
            "@type": "wx:ObservationStation",
            "elevation": [
                "value": 1481.0232,
                "unitCode": "unit:m"
            ],
            "stationIdentifier": "KRXE",
            "name": "Rexburg, Rexburg-Madison County Airport",
            "timeZone": "America/Boise"
        ]
    ]
    
    func test_Station_InitWithProperData() {
        let station = Station(json: goodJson)
        
        XCTAssertNotNil(station)
        XCTAssertEqual(station?.abbreviation, "KRXE")
        XCTAssertEqual(station?.coordinates.latitude, 43.83167)
        XCTAssertEqual(station?.coordinates.longitude, -111.80611)
        XCTAssertEqual(station?.dataUrl, URL(string: "https://api.weather.gov/stations/KRXE")!)
        XCTAssertEqual(station?.name, "Rexburg, Rexburg-Madison County Airport")
        XCTAssertEqual(station?.timezone, "America/Boise")
    }
    
    func test_Station_InitReturnsNilWithBadData() {
        let badJson: [String: Any] = ["id": 2345, "name": true]
        let station = Station(json: badJson)
        XCTAssertNil(station)
    }
    
    func test_Coordinates_InitWithProperData() {
        [(123.456, 987.654),
         (-123.456, 987.654),
         (123.456, -987.654),
         (-123.456, -987.654)].forEach { (latitude, longitude) in
            let coords = Coordinates(coordinateArray: [longitude, latitude])
            
            XCTAssertEqual(coords?.latitude, latitude)
            XCTAssertEqual(coords?.longitude, longitude)
        }
    }
    
    func test_Coordinates_InitReturnsNilWithBadData() {
        [[],
         [1.0],
         [1.0, -2.0, 3.0]].forEach { coordArray in
            let coords = Coordinates(coordinateArray: coordArray)
            XCTAssertNil(coords)
        }
    }
}
