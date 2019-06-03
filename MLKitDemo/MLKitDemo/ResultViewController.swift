//
//  ResultViewController.swift
//  MLKitDemo
//
//  Created by Ekachai Limpisoot on 2/6/2562 BE.
//  Copyright © 2562 Ekachai Limpisoot. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var image : UIImage?
    var resultString : String?
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Result"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let image = self.image,let resultString = self.resultString else{
            return
        }
        resultImageView.image = image
        resultLabel.text = resultString
    }
}
