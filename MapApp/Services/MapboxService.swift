//
//  MapboxService.swift
//  MapApp
//
//  Created by OstapMamykin on 14.04.2026.
//

import Foundation

struct PlaceResult {
    let name: String
    let longitude: Double
    let latitude: Double
}

final class MapboxService {
    private let token = "secret_key"

    func searchPlace(query: String, completion: @escaping (PlaceResult?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(nil)
            return
        }

        let urlString = "https://api.mapbox.com/geocoding/v5/mapbox.places/\(encodedQuery).json?access_token=\(token)&limit=1&language=ru"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                error == nil,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let features = json["features"] as? [[String: Any]],
                let first = features.first,
                let placeName = first["place_name"] as? String,
                let center = first["center"] as? [Double],
                center.count >= 2
            else {
                completion(nil)
                return
            }

            let result = PlaceResult(
                name: placeName,
                longitude: center[0],
                latitude: center[1]
            )

            completion(result)
        }.resume()
    }
}
