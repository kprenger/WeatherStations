//
//  StationViewControllerTest.swift
//  WeatherStationsTests
//
//  Created by Kurt Prenger on 3/21/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import XCTest
@testable import WeatherStations

class StationViewControllerTest: XCTestCase {
    
    var stationViewController: StationViewController!

    override func setUp() {
        super.setUp()
        stationViewController = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController)
        
        // This forces the view hierarchy to load
        _ = stationViewController.view
    }

    override func tearDown() {
        stationViewController = nil
        super.tearDown()
    }
    
    // MARK: - updateData()
    
    func test_UpdateData_LabelsSetWithCorrectData() {
        guard let testData = makeStationsData() else {
            XCTFail("Could not make test [Station] data")
            return
        }
        
        let station = testData[0]
        stationViewController.station = station
        stationViewController.updateData()
        
        XCTAssertEqual(stationViewController.nameLabel.text,
                       "\(station.name)\n(\(station.abbreviation))")
        XCTAssertEqual(stationViewController.coordinatesLabel.text,
                       "[\(station.coordinates.latitude), \(station.coordinates.longitude)]")
    }
    
    func test_UpdateData_DoesNotSetDataIfNoStation() {
        stationViewController.nameLabel.text = "The name will not change"
        stationViewController.coordinatesLabel.text = "The coordinates will not change"
        
        stationViewController.updateData()
        
        XCTAssertEqual(stationViewController.nameLabel.text, "The name will not change")
        XCTAssertEqual(stationViewController.coordinatesLabel.text, "The coordinates will not change")
    }
}

extension StationViewControllerTest {
    func makeStationsData() -> [Station]? {
        let testBundle = Bundle(for: type(of: self))
        
        guard let path = testBundle.path(forResource: "stations", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let stationArray = json?["features"] as? [[String: Any]] else { return nil }
        
        let stations = stationArray.compactMap { json in Station(json: json) }
        return stations
    }
}
