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
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func zoomToCurrentLocation(_ location: CLLocationCoordinate2D) {
        let delta: Double = 0.02
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.positionMapView.setRegion(region, animated: true)
    }
    
    func showPhotoDetail() {
        DispatchQueue.main.async {
            // update info on view
            self.titleLabel.text = self.photo?.title
            self.despLabel.text = self.photo?.resultDescription
            self.positionLabel.text = "Position: \(self.photo?.position.latitude ?? 0),\(self.photo?.position.longitude ?? 0)"
            self.photoImageView.image = UIImage(data: self.photoData!)
            
            // show a pin on map
            let coord = CLLocationCoordinate2D(latitude: self.photo?.position.latitude ?? 0, longitude: self.photo?.position.longitude ?? 0)
            let pin = PhotoAnnotation(title: self.photo?.title ?? "Here", coordinate: coord, photoId: self.photo?.id ?? 0)
            self.positionMapView.addAnnotation(pin)
            self.zoomToCurrentLocation(coord)
        }
    }

    
}
