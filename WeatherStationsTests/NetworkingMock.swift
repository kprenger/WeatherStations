//
//  NetworkingMock.swift
//  WeatherStationsTests
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import Foundation
@testable import WeatherStations

class NetworkingMock: NetworkingProtocol {
    var stationsData: [Station]!
    
    func getStationData(completion: @escaping ([Station]?, Error?) -> Void) {
        completion(stationsData, nil)
    }
}
