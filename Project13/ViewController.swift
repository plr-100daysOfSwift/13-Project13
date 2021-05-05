//
//  ViewController.swift
//  Project13
//
//  Created by Paul Richardson on 06/05/2021.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!

	var currentImage: UIImage!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func intensityChanged(_ sender: UISlider) {
	}

	@IBAction func changeFilter(_ sender: UIButton) {
	}

	@IBAction func save(_ sender: UIButton) {
	}

}

