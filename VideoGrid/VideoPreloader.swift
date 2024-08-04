//
//  VideoPreloader.swift
//  VideoGrid
//
//  Created by Shwetangi Gurav on 04/08/24.
//

import AVFoundation

class VideoPreloader {
    static let shared = VideoPreloader()
    private var preloadingQueue = OperationQueue()
    
    func preloadVideo(with url: URL) {
        let operation = BlockOperation {
            let asset = AVURLAsset(url: url)
            let keys = ["playable"]
            asset.loadValuesAsynchronously(forKeys: keys) {
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "playable", error: &error)
                if status == .loaded {
                    print("Video preloaded successfully")
                } else {
                    print("Error preloading video: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        preloadingQueue.addOperation(operation)
    }
}

