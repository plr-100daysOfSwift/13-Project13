//
//  ViewController.swift
//  Project13
//
//  Created by Paul Richardson on 06/05/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!

	var currentImage: UIImage!

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Instafilter"

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
	}

	@IBAction func intensityChanged(_ sender: UISlider) {
	}

	@IBAction func changeFilter(_ sender: UIButton) {
	}

	@IBAction func save(_ sender: UIButton) {
	}

	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}

}

