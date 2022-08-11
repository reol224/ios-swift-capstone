//
//  PhotoDetail.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/6.
//

import UIKit
import MapKit
import CoreLocation

class PhotoDetail: UIViewController {

    var photoId : Int? // receive photo id from map view
    var photo : Photo? // save photo info
    var photoData : Data? // save image data
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    @IBOutlet weak var positionMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("-----> \(photoId!)")

        // fetch photo info
        getPhotoDetailAsync(id: photoId!, completion: { photo in
            self.photo = photo // save to class level variable
            
            // fetch the photo image data
            getPhotoThumbnail(photo.thumbURL!, completion: { data in
                self.photoData = data // save to class level variable
                self.showPhotoDetail() // then show the photo
            })
        })
    }
    
    func showPhotoDetail() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.photo?.title
            self.despLabel.text = self.photo?.resultDescription
            self.photoImageView.image = UIImage(data: self.photoData!)
        }
    }

    
}
