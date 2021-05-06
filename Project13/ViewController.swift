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
		applyProcessing()
	}

	@IBAction func changeFilter(_ sender: UIButton) {
		let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	@IBAction func save(_ sender: UIButton) {
	}

	// MARK:- ImagePicker Delegate Methods

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		currentImage = image

		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()

	}

	// MARK:- Private Methods

	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}

	func applyProcessing() {
		guard let image = currentFilter.outputImage else { return }
		currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

		if let cgimg = context.createCGImage(image, from: image.extent) {
			let processedImage = UIImage(cgImage: cgimg)
			imageView.image = processedImage
		}
	}

	func setFilter(action: UIAlertAction) {

	}

}


