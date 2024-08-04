//
//  VideoModel.swift
//  VideoGrid
//
//  Created by Shwetangi Gurav on 04/08/24.
//

import Foundation

struct ReelResponse: Codable {
    let reels: [Reel]
}

struct Reel: Codable {
    let arr: [Video]
}

struct Video: Codable {
    let _id: String
    let video: String
    let thumbnail: String
}
