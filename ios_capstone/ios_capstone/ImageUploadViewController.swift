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
    @IBOutlet weak var infoShow: UILabel!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDescribe: UITextField!
    var latitude = "0.0000"
    var longitude = "0.0000"
    var imageSelected = UIImage()
    var imageSelectedName = ""
    var uploadImgUrl = ""
    var uploadImgTbUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // image interaction tap
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // dict transfor json
    func convertDictionaryToJSONString(dict:NSDictionary?)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
    
    func uploadImgForUrl(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "https://capstone.freeyeti.net/api/photos/upload")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        //print(data)
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    self.uploadImgUrl = json["image_url"]! as! String
                    self.uploadImgTbUrl = json["thumb_url"]! as! String
                    print(json)
                }
            }
        }).resume()
    }
    
    func uploadImgToDatabase(url: String, thumb_url: String){
        // step2 upload info to database
        // set url
        let session = URLSession(configuration: .default)
        let url = "https://capstone.freeyeti.net/api/photos/"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // post dict
        let postData = ["title":itemTitle.text!,"description":itemDescribe.text!,"keywords": itemTitle.text!,"url": "https://capstone.freeyeti.net\(url)",
                        "thumb_url": "https://capstone.freeyeti.net\(thumb_url)","position": [
                            "latitude": latitude,
                            "longitude": longitude
                        ]] as [String : Any]

        let postString = convertDictionaryToJSONString(dict: postData as NSDictionary)
        //print(postString)
        request.httpBody = postString.data(using: .utf8)
        // task for post
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
            } catch {
                print("network error")
                return
            }
        }
        task.resume()
    }
    
    // upload file start
    @IBAction func uploadImage(_ sender: Any) {
        
        if itemTitle.text == "" || itemDescribe.text == "" {
            infoShow.text = "please fill in all field"
            return
        }
        infoShow.text = "uploading..."
        
        if uploadImgUrl != "" && uploadImgTbUrl != "" {
            //step2 upload database
            uploadImgToDatabase(url: uploadImgUrl, thumb_url: uploadImgTbUrl)
            
            infoShow.text = "Upload Successfully"
            uploadImgUrl = ""
            uploadImgTbUrl = ""
            itemTitle.text = ""
            itemDescribe.text = ""
            position.text = ""
        }
        
    }
    
}

// set delegate for picker
extension ImageUploadViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else {
            return
          }

          let imageResult = results[0]
            // change imageVIew
            imageResult.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
               if let image = object as? UIImage {
                self.imageSelected = image
                imageResult.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                        guard let url = url else {
                            return
                        }
                    //print( url.absoluteURL)
                    // set selected image url and url name
                    self.imageSelectedName = url.lastPathComponent
                    self.uploadImgForUrl(paramName: "photo", fileName: url.lastPathComponent, image: image)
                    }
                  DispatchQueue.main.async {
                     // Use UIImage
                    self.imageView.image = image
                    //step1 create a URLSession
                    
                  }
               }
            })
        
        
        
        
          // get image Assets info
          if let assetId = imageResult.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            position.text = "\(String(describing: assetResults.firstObject?.location?.coordinate.latitude ?? 0.0000))   \(String(describing: assetResults.firstObject?.location?.coordinate.longitude ?? 0.0000))"
            latitude = "\(String(describing: assetResults.firstObject?.location?.coordinate.latitude ?? 0.0000))"
            longitude = "\(String(describing: assetResults.firstObject?.location?.coordinate.longitude ?? 0.0000))"
            
            //print(assetResults.firstObject?.description ?? "No date")
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
