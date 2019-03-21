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
    
    // MARK: - numberOfSections(in tableView: UITableView) -> Int

    func test_NumberOfSections_IsOne() {
        XCTAssertEqual(stationsTableViewController.tableView.numberOfSections, 1)
    }
    
    // MARK: - tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    
    func test_NumberOfRows_IsOneWhileDataIsFetched() {
        XCTAssertEqual(stationsTableViewController.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_NumberOfRows_IsOneIfDataIsNil() {
        let promise = expectation(description: "Data is fetched")
        let networkingMock = NetworkingMock()
        networkingMock.stationsData = nil
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(stationsTableViewController.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_NumberOfRows_IsOneIfFetchErrors() {
        let promise = expectation(description: "Data is fetched")
        let networkingMock = NetworkingMock()
        networkingMock.shouldError = true
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
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
    
    // MARK: - tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func test_CellForRow_IsLoadingCellWhileDataIsFetched() {
        let tableView = stationsTableViewController.tableView!
        let cell = stationsTableViewController.tableView(tableView,
                                                         cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.textLabel?.text, "Fetching Data...")
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
    
    func test_CellForRow_NoDataCellIfDataIsNil() {
        let promise = expectation(description: "Fetch errors")
        let networkingMock = NetworkingMock()
        networkingMock.stationsData = nil
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let tableView = stationsTableViewController.tableView!
        let cell = stationsTableViewController.tableView(tableView,
                                                         cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.textLabel?.text, "No Data Found")
    }
    
    func test_CellForRow_NoDataCellIfFetchErrors() {
        let promise = expectation(description: "Fetch errors")
        let networkingMock = NetworkingMock()
        networkingMock.shouldError = true
        
        stationsTableViewController.networking = networkingMock
        stationsTableViewController.fetchStationData {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let tableView = stationsTableViewController.tableView!
        let cell = stationsTableViewController.tableView(tableView,
                                                         cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.textLabel?.text, "No Data Found")
    }
    
    // MARK: - tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    
    func test_WillSelectRow_SetsCorrectStation() {
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
            let _ = stationsTableViewController.tableView(tableView, willSelectRowAt: IndexPath(row: index, section: 0))
            XCTAssertEqual(stationsTableViewController.selectedStation!, station)
        }
    }
    
    // MARK: - func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    func test_PrepareForSegue_SendsCorrectInfo() {
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
        
        let stationVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController)
        let segue = UIStoryboardSegue(identifier: "testPrepareForSegue", source: stationsTableViewController, destination: stationVC)
        
        for (index, station) in sortedData.enumerated() {
            let _ = stationsTableViewController.tableView(tableView, willSelectRowAt: IndexPath(row: index, section: 0))
            XCTAssertNotNil(stationsTableViewController.selectedStation)
            
            stationsTableViewController.prepare(for: segue, sender: nil)
            
            XCTAssertEqual(stationVC.station, station)
            XCTAssertNil(stationsTableViewController.selectedStation)
        }
    }
    
    func test_PrepareForSegue_DoesNothingIfUnassociatedVCSent() {
        guard let testData = makeStationsData() else {
            XCTFail("Could not make test [Station] data")
            return
        }
        
        let segue = UIStoryboardSegue(identifier: "testPrepareForSegue", source: stationsTableViewController, destination: UIViewController())
        stationsTableViewController.selectedStation = testData[0]
        
        XCTAssertNotNil(stationsTableViewController.selectedStation)
        
        stationsTableViewController.prepare(for: segue, sender: nil)
        
        // The `selectedStation` is set to `nil` if `prepare()` is called with the correct VC
        // In this case, it is not, so we expect the `selectedStation` not to be reset
        XCTAssertNotNil(stationsTableViewController.selectedStation)
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
