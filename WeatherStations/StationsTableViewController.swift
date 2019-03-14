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
    let stationCellId = "stationCell"
    
    var isFetchingStationData = true
    var stations: [Station] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStationData()
    }
    
    func fetchStationData() {
        Networking().getStationData { [weak self] (data, error) in
            guard let data = data, error == nil, let self = self else { return }
            
            self.stations = data.sorted { a, b in a.name < b.name }
            
            DispatchQueue.main.async {
                self.isFetchingStationData = false
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Table view data source

extension StationsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFetchingStationData ? 1 : stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = isFetchingStationData ? loadingCellId : stationCellId
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else { return UITableViewCell() }
        
        if (isFetchingStationData) {
            return cell
        }
        
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.name
        
        return cell
    }
}
