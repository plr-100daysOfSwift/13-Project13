//
//  ViewController.swift
//  Project13
//
//  Created by Paul Richardson on 06/05/2021.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!
	@IBOutlet var count: UISlider!
	@IBOutlet var filterButton: UIButton!
	
	var currentImage: UIImage!
	var context: CIContext!
	var currentFilter: CIFilter!

	enum Filter: String, CaseIterable {
		case CIBumpDistortion
		case CIGaussianBlur
		case CIPixellate
		case CISepiaTone
		case CITwirlDistortion
		case CIKaleidoscope
		case CIVignette

		var title: String {
			return CIFilter(name: self.rawValue)?.attributes["CIAttributeFilterDisplayName"] as! String
		}
	}

	// MARK:- Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Instafilter"

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

		context = CIContext()
		let defaultFilter: CIFilter = CIFilter.sepiaTone()
		currentFilter = defaultFilter
		setFilterButtonTitle(currentFilter)
		// TODO: Why is count 3 rather than 6?

	}

	// MARK:- IBActions

	@IBAction func valueChanged(_ sender: UISlider) {
		// TODO: Disable sliders if no image present
		guard let _ = imageView.image else { return }
		applyProcessing()
	}

	@IBAction func changeFilter(_ sender: UIButton) {
		let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
		let _ = Filter.allCases.map {
			ac.addAction(UIAlertAction(title: $0.title, style: .default, handler: setFilter))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		if let popoverController = ac.popoverPresentationController {
			popoverController.sourceView = sender
			popoverController.sourceRect = sender.bounds
		}

		present(ac, animated: true)
	}

	@IBAction func save(_ sender: UIButton) {
		guard let image = imageView.image else {
			let ac = UIAlertController(title: "No image", message: "Please load an image before saving.", preferredStyle: .alert)
			ac .addAction(UIAlertAction(title: "OK", style: .cancel))
			present(ac, animated: true)
			return

		}
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

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

	fileprivate func setFilterButtonTitle(_ filter: CIFilter) {
		let title = filter.attributes["CIAttributeFilterDisplayName"] ?? "Unknown"
		filterButton.setTitle("Filter: \(title)", for: .normal)
	}

	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}

	func applyProcessing() {
		let inputKeys = currentFilter.inputKeys

		if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
		if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)}
		if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)}
		if inputKeys.contains(kCIInputAngleKey) { currentFilter.setValue(intensity.value * 5, forKey: kCIInputAngleKey)}
		if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)}
		// TODO: where is kCIInputCount?
		if inputKeys.contains("inputCount") { currentFilter.setValue(count.value, forKey: "inputCount") }

		guard let image = currentFilter.outputImage else { return }
		if let cgImage = context.createCGImage(image, from: image.extent) {
			let processedImage = UIImage(cgImage: cgImage)
			imageView.image = processedImage
		}
	}

	func setFilter(action: UIAlertAction) {
		guard let actionTitle = action.title,
					let filter = Filter.allCases.first(where: {$0.title == actionTitle})
					else { return }
		currentFilter = CIFilter(name: filter.rawValue)
		self.setFilterButtonTitle(currentFilter)

		guard currentImage != nil else { return }
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
	}

	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		let ac: UIAlertController

		if let error = error {
			ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
		} else {
			ac = UIAlertController(title: "Saved", message: "The filtered image has been saved to the photos library.", preferredStyle: .alert)
		}
		ac.addAction(UIAlertAction(title: "OK", style: .default))

		present(ac, animated: true)
	}

}
