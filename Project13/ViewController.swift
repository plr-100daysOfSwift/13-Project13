//
//  ViewController.swift
//  Project13
//
//  Created by Paul Richardson on 06/05/2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!

	var currentImage: UIImage!
	var context: CIContext!
	var currentFilter: CIFilter!

	// MARK:- Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Instafilter"

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

		context = CIContext()
		currentFilter = CIFilter(name: "CISepiaTone")

	}

	// MARK:- IBActions
	
	@IBAction func intensityChanged(_ sender: UISlider) {
	}

	@IBAction func changeFilter(_ sender: UIButton) {
	}

	@IBAction func save(_ sender: UIButton) {
	}

	// MARK:- ImagePicker Delegate Methods

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		currentImage = image
	}

	// MARK:- Private Methods

	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}

}

