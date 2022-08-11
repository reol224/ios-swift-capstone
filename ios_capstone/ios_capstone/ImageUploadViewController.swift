//
//  ViewController.swift
//  ios_capstone
//
//  Created by zhoufeng on 2022/8/11.
//

import UIKit

class ImageUploadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController();
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

extension ImageUploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
}
