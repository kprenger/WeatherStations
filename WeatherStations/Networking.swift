//
//  Networking.swift
//  WeatherStations
//
//  Created by Kurt Prenger on 3/14/19.
//  Copyright © 2019 MTS. All rights reserved.
//

import Foundation

struct NetworkingError: Error {
    var code: Int?
    var message: String?
}

class Networking {
    let baseUrl = "https://api.weather.gov/"
    let stations = "stations"
    
    func getStationData(completion: @escaping ([Station]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: baseUrl + stations)!) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, NetworkingError(code: (response as? HTTPURLResponse)?.statusCode,
                                                   message: "Received a non-successful response"))
                    return
            }
            
            guard let mimeType = httpResponse.mimeType,
                mimeType.contains("json"),
                let data = data,
                let json =
                    try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let stationArray = json?["features"] as? [[String: Any]] else {
                    completion(nil, NetworkingError(code: 1, message: "Unable to parse response"))
                    return
            }
            
            let stations = stationArray.compactMap { json in Station(json: json) }
            
            completion(stations, nil)
        }
        
        task.resume()
    }
}
