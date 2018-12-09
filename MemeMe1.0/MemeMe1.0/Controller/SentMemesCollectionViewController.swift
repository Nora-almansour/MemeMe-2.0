//
//  SentMemeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Nora al-mansour on 3/26/1440 AH.
//  Copyright © 1440 Nora al-mansour. All rights reserved.
//

import UIKit


class SentMemesCollectionViewController: UICollectionViewController {
    
    @ IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Implement flowLayout here.
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if collectionView != nil {
            collectionView?.reloadData()
        }
    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Start creating a new Meme."
            collectionView!.backgroundView = label
        } else {
            collectionView!.backgroundView = nil
        }
    }
// MARK: Push from Collection into MemeDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemeDetail" {
            if let cell = sender as? SentMemeCollectionViewCell {
                let detailView = segue.destination as! MemeDetailViewController
                detailView.memeToShow = appDelegate.memes[(collectionView?.indexPath(for: cell)?.row)!]
            }
        }
    }
    // MARK: Set-up Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme: MemeObject = appDelegate.memes[indexPath.row]
        cell.cellImageView!.image = meme.memedImage
        return cell
    }
}








