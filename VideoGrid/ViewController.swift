//
//  ViewController.swift
//  VideoGrid
//
//  Created by Shwetangi Gurav on 04/08/24.
//
import UIKit

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataLoader = DataLoader()
    var reels: [Reel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadReelsData()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        view.addSubview(collectionView)
    }

    private func loadReelsData() {
        if let data = dataLoader.loadReelsData() {
            reels = data.reels
            collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.configure(with: reels[indexPath.section].arr)
        return cell
    }
    
}
