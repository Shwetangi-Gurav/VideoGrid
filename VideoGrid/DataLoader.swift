//
//  DataLoader.swift
//  VideoGrid
//
//  Created by Shwetangi Gurav on 04/08/24.
//

import Foundation

class DataLoader {
    func loadReelsData() -> ReelResponse? {
        guard let path = Bundle.main.path(forResource: "reels", ofType: "json") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ReelResponse.self, from: data)
            return response
        } catch {
            print("Error loading data: \(error)")
            return nil
        }
    }
}
