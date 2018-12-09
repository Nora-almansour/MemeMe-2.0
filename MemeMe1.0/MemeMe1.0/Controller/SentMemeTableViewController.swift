//
//  SentMemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Nora al-mansour on 3/26/1440 AH.
//  Copyright © 1440 Nora al-mansour. All rights reserved.
//

import UIKit


class SentMemeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: EmptyView Customizing: 
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Start creating a new Meme."
            tableView.separatorStyle = .none
            tableView.backgroundView = label
            navigationItem.leftBarButtonItem = nil
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
     // MARK: TableView
    // numberOfRowsInSection:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    //cellForRowAt indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell", for: indexPath) as! SentMemeTableViewCell
        let meme: MemeObject = appDelegate.memes[indexPath.row]
        cell.cellImageView.image = meme.memedImage
        cell.cellTopTextLabel.text = meme.topText
        cell.cellBottomTextLabel.text = meme.bottomText
        return cell
    }
    //
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
     // MARK: Push from Table into MemeDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemeDetail" {
            if let cell = sender as? SentMemeTableViewCell {
                let detailView = segue.destination as? MemeDetailViewController
                detailView?.memeToShow = appDelegate.memes[(tableView.indexPath(for: cell)?.row)!]
            }
        }
    }
}

