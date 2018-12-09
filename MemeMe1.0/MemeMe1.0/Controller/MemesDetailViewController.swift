//
//  MemesDetailViewController.swift
//  MemeMe1.0
//
//  Created by Nora al-mansour on 3/26/1440 AH.
//  Copyright © 1440 Nora al-mansour. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    // MARK: Properties
    var memeToShow: MemeObject!
  
    // MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      memeImageView.image = memeToShow!.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeToShow!.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

