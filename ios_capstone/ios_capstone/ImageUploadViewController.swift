//
//  ViewController.swift
//  ios_capstone
//
//  Created by zhoufeng on 2022/8/11.
//

import UIKit
import PhotosUI

class ImageUploadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var position: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

// set delegate for picker
extension ImageUploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else {
            return
          }
//          let identifiers = results.compactMap(\.assetIdentifier)
//          let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
//          print(fetchResult)
          let imageResult = results[0]
            // change imageVIew
            imageResult.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
               if let image = object as? UIImage {
                  DispatchQueue.main.async {
                     // Use UIImage
                    self.imageView.image = image
                  }
               }
            })
          // get image Assets info
          if let assetId = imageResult.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            position.text = "\(String(describing: assetResults.firstObject?.location?.coordinate.latitude ?? 0.0000))   \(String(describing: assetResults.firstObject?.location?.coordinate.longitude ?? 0.0000))"
          
//            print(assetResults.firstObject?.creationDate ?? "No date")
//            print(assetResults.firstObject?.location?.coordinate.latitude ?? "No location")
          }
                    
    }
    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // dismiss photo library
//        picker.dismiss(animated: false, completion: nil)
//        // set imageView the selected image
//        imageView.image = info[.originalImage] as? UIImage
//
//        // get selected image's metaData: Asset, creation Data, Location
//
//    }
}
