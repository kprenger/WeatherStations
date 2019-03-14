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

    func testStationInitWithProperData() {
        let testJSON: [String: Any] = [
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
        
        let station = Station(json: testJSON)
        
        XCTAssertNotNil(station)
        XCTAssertEqual(station?.abbreviation, "KRXE")
        XCTAssertEqual(station?.coordinates.latitude, 43.83167)
        XCTAssertEqual(station?.coordinates.longitude, -111.80611)
        XCTAssertEqual(station?.dataUrl, URL(string: "https://api.weather.gov/stations/KRXE")!)
        XCTAssertEqual(station?.name, "Rexburg, Rexburg-Madison County Airport")
        XCTAssertEqual(station?.timezone, "America/Boise")
    }
    
    func testStationReturnsNilWithBadData() {
        let badJSON: [String: Any] = ["id": 2345, "name": true]
        let station = Station(json: badJSON)
        XCTAssertNil(station)
    }
    
    func testCoordinatesInitWithProperData() {
        [(123.456, 987.654),
         (-123.456, 987.654),
         (123.456, -987.654),
         (-123.456, -987.654)].forEach { (latitude, longitude) in
            let coords = Coordinates(coordinateArray: [longitude, latitude])
            
            XCTAssertEqual(coords?.latitude, latitude)
            XCTAssertEqual(coords?.longitude, longitude)
        }
    }
    
    func testCoordinatesReturnsNilWithBadData() {
        [[],
         [1.0],
         [1.0, -2.0, 3.0]].forEach { coordArray in
            let coords = Coordinates(coordinateArray: coordArray)
            XCTAssertNil(coords)
        }
    }
}
