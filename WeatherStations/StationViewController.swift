//
//  StationViewController.swift
//  WeatherStations
//
//  Created by Kurt Prenger on 3/15/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import UIKit

class StationViewController: UIViewController {
    
    var station: Station?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateData() {
        guard let station = station else { return }
        
        nameLabel.text = "\(station.name)\n(\(station.abbreviation))"
        coordinatesLabel.text = "[\(station.coordinates.latitude), \(station.coordinates.longitude)]"
    }
}
