//
//  ViewController.swift
//  ios_capstone
//
//  Created by zhoufeng on 2022/8/11.
//
/*
 Group INFO
 Jianxuan Li (8807952)
 Iulia Danilov (8816991)
 Krupa Suhagiya (8813230)
 Smit Mehta (8813480)
 Feng Zhou (8808141)
 Parshwa Shah (8836740)
 */

import UIKit
import PhotosUI

class ImageUploadViewController: UIViewController {

    // UI fields define
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var infoShow: UILabel!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDescribe: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    // global variable to save upload info
    var latitude = "0.0000"
    var longitude = "0.0000"
    var imageSelected = UIImage()
    var imageSelectedName = ""
    var uploadImgUrl = ""
    var uploadImgTbUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // when tap the outside of input fields close keyboard
        // when tap the ouside of input fields close keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
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
    
    // process upload and analyzing pic control
    func setPostionFieldValue(cmd: String) {
        DispatchQueue.main.async {
            switch cmd {
            case "analyzing":
                self.position.text = "Please wait while analyzing..."
            case "uploadPicOk":
                self.position.text = "\(self.latitude) \(self.longitude)"
            case "uploadPicError":
                self.position.text = "error, please try again"
            case "reset":
                self.position.text = ""
            default:
                self.position.text = ""
            }
        }
    }
    
    // upload step1 upload pic to aws for get 2 url info
    // api:
    // request post:multipart/form-data
    //          paramName: {"photo"}, fileName: {"absolute address"}, image: UIImage()
    // response: Dict
    //        ["thumb_url": {}, "image_url": {}]
    func uploadImgForUrl(paramName: String, fileName: String, image: UIImage) {
        setPostionFieldValue(cmd: "analyzing")
        let url = URL(string: "https://capstone.freeyeti.net/api/photos/upload")

        // create boundary string using UUID().uuidString
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        // define method POST
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent for submitting form data with file just like html form
        // start add boundary info
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
                    guard let imgUrl: String = json["image_url"] as? String else {
                        print("imgUrl error")
                        return
                    }
                    
                    guard let imgTbUrl: String = json["thumb_url"] as? String else {
                        print("imgTbUrl error")
                        return
                    }
                    // set 2 urls
                    self.uploadImgUrl = imgUrl
                    self.uploadImgTbUrl = imgTbUrl
                    print(json)
                    self.setPostionFieldValue(cmd: "uploadPicOk")
                }
            }else {
                self.setPostionFieldValue(cmd: "uploadPicError")
            }
        }).resume()
    }
    
    
    // upload title describe and aws url info to database
    //
    func uploadImgToDatabase(url: String, thumb_url: String){
        // step2 upload info to database
        // api:
        // request post:json
        //        {
        //            "title": "",
        //            "description": "",
        //            "keywords": "",
        //            "url": "",
        //            "thumb_url": "",
        //            "position": null
        //        }
        // response json like request
        // create URLSession
        let session = URLSession(configuration: .default)
        // this is the api url
        let url = "https://capstone.freeyeti.net/api/photos/"
        // create request object then config setValue, httpBody
        var req = URLRequest(url: URL(string: url)!)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        // post dict
        let postData = ["title":itemTitle.text!,"description":itemDescribe.text!,"keywords": itemTitle.text!,"url": "https://capstone.freeyeti.net\(url)",
                        "thumb_url": "https://capstone.freeyeti.net\(thumb_url)","position": [
                            "latitude": latitude,
                            "longitude": longitude
                        ]] as [String : Any]

        let postString = convertDictionaryToJSONString(dict: postData as NSDictionary)
        //print(postString)
        req.httpBody = postString.data(using: .utf8)
        // task for post
        let task = session.dataTask(with: req) { (data, response, error) in
            do { // serializetion data
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                self.showSuccessfully()
            } catch {
                print("network error")
                return
            }
        }
        task.resume()
    }
    
    // upload btn action file start
    @IBAction func uploadImage(_ sender: Any) {
        
        if uploadImgUrl == "" || uploadImgTbUrl == "" {
            infoShow.text = "please do step1 first"
            return
        }
        
        if latitude == "0.0000" || longitude == "0.0000" {
            infoShow.text = "Please wait for the analysis to complete"
            return
        }
        
        if itemTitle.text == "" || itemDescribe.text == "" {
            infoShow.text = "please fill in all field"
            return
        }
        
        //post data to database
        uploadImgToDatabase(url: uploadImgUrl, thumb_url: uploadImgTbUrl)
        
    }
    
    
    
    // alert to show successfully upload
    func showSuccessfully() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "successfully", message: "Congratulations, go to the photo list page and take a look", preferredStyle: .alert)
     
            // add action
            let okAction = UIAlertAction(title: "go", style: .default, handler: {
                action in
                self.tabBarController?.selectedIndex = 0
                //self.performSegue(withIdentifier: "goto_Photos", sender: self)
                
                self.uploadImgUrl = ""
                self.uploadImgTbUrl = ""
                self.itemTitle.text = ""
                self.itemDescribe.text = ""
                self.position.text = ""
                self.latitude = "0.0000"
                self.longitude = "0.0000"
                self.infoShow.text = ""
                self.imageView.image = UIImage(named:"upload")
                
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
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
                imageResult.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [self] (url, error) in
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
