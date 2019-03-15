//
//  StationsTableViewControllerTest.swift
//  WeatherStationsTests
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import XCTest
@testable import WeatherStations

class StationsTableViewControllerTest: XCTestCase {

    var stationsTableViewController: StationsTableViewController!
    
    override func setUp() {
        super.setUp()
        stationsTableViewController = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationsTableViewController") as! StationsTableViewController)
    }

    override func tearDown() {
        stationsTableViewController = nil
        super.tearDown()
    }

    func test_NumberOfSections_IsOne() {
        XCTAssertEqual(stationsTableViewController.tableView.numberOfSections, 1)
    }
    
    func test_NumberOfRows_IsOneWhileDataIsFetched() {
        XCTAssertEqual(stationsTableViewController.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_NumberOfRows_IsCountOfStationData() {
        XCTAssertEqual(stationsTableViewController.tableView.numberOfRows(inSection: 0),
                       1,
                       "Number of Rows is 1 while fetching")
        
        guard let testData = makeStationsData() else {
            XCTFail("Could not make test [Station] data")
            return
        }
        
        let promise = expectation(description: "Data is fetched")
        let networkingMock = NetworkingMock()
        networkingMock.stationsData = testData
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(stationsTableViewController.tableView.numberOfRows(inSection: 0),
                       testData.count,
                       "Number of Rows is the count of data array after fetching")
    }
    
    func test_CellForRow_IsLoadingCellWhileDataIsFetched() {
        let tableView = stationsTableViewController.tableView!
        let cell = stationsTableViewController.tableView(tableView,
                                                         cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.textLabel?.text, "Fetching data...")
    }
    
    func test_CellForRow_UsesCorrectDataAfterFetched() {
        guard let testData = makeStationsData() else {
            XCTFail("Could not make test [Station] data")
            return
        }
        
        let promise = expectation(description: "Data is fetched")
        let networkingMock = NetworkingMock()
        networkingMock.stationsData = testData
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let tableView = stationsTableViewController.tableView!
        let sortedData = testData.sorted { (a, b) in a.name < b.name }
        
        for (index, station) in sortedData.enumerated() {
            let cell = stationsTableViewController.tableView(tableView,
                                                             cellForRowAt: IndexPath(row: index, section: 0))
            XCTAssertEqual(cell.textLabel?.text, station.name)
        }
    }
}

// MARK: - Test utilities

extension StationsTableViewControllerTest {
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
