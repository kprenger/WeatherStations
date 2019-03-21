//
//  StationsTableViewController.swift
//  WeatherStations
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import UIKit

class StationsTableViewController: UITableViewController {
    
    let loadingCellId = "loadingCell"
    let noDataCellId = "noDataCell"
    let stationCellId = "stationCell"
    
    var isFetchingStationData = true
    var networking: NetworkingProtocol!
    var stations: [Station] = []
    var selectedStation: Station?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (networking == nil) {
            networking = Networking()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStationData()
    }

    func fetchStationData(completion: (() -> ())? = nil) {
        networking.getStationData { [weak self] (data, error) in
            defer {
                DispatchQueue.main.async {
                    self?.isFetchingStationData = false
                    self?.tableView.reloadData()
                    completion?()
                }
            }
            
            guard let data = data, error == nil, let self = self else { return }
            
            self.stations = data.sorted { a, b in a.name < b.name }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let stationVC = segue.destination as? StationViewController else { return }
        
        stationVC.station = selectedStation
        selectedStation = nil
    }
}

// MARK: - Table view data source

extension StationsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFetchingStationData || stations.count == 0 {
            return 1
        } else {
            return stations.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = stationCellId
        
        if isFetchingStationData {
            cellId = loadingCellId
        } else if stations.count == 0 {
            cellId = noDataCellId
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else { return UITableViewCell() }
        
        if (isFetchingStationData || stations.count == 0) {
            return cell
        }
        
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.name
        
        return cell
    }
}

// MARK: - Table view delegate

extension StationsTableViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedStation = stations[indexPath.row]
        
        return indexPath
    }
}
