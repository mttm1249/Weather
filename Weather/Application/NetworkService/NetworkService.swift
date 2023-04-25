//
//  NetworkService.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import Foundation

class NetworkService {

    private init() {}

    static let shared = NetworkService()

    func getData(url: URL, headers: [String: String] = [:], completionHandler: @escaping (Result<Data, Error>) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                completionHandler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            completionHandler(.success(data))
        }.resume()
    }
}

