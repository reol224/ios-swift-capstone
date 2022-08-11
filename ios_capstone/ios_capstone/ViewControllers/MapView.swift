//
//  MapView.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/11.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    private var imageData: [String: Data] = [:]
    private var selectedPhotoId: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        loadPhotoData()
    }
    
    // display photo on annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }

        let photoAnnotation = annotation as! PhotoAnnotation // use PhotoAnnotation type here
        let imgData = self.imageData[String(photoAnnotation.photoId)] // get image data by photo id

        let reuseId = "PhotoAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if (annotationView == nil){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let image = PhotoUIImage(data: imgData!)
            let scaledImage = image!.scalePreservingAspectRatio(
                targetSize: CGSize(width: 60, height: 60)
            ) // resize the image to 60 x 60
            annotationView?.image = scaledImage
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    // when user click on the photo
    // ref: https://stackoverflow.com/questions/43962457/use-mkannotation-to-move-on-the-next-view-controller
    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        let photoAnnotation = annotationView.annotation as! PhotoAnnotation
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailVC = storyBoard.instantiateViewController(withIdentifier: "PhotoDetail") as! PhotoDetail
        photoDetailVC.photoId = photoAnnotation.photoId
        navigationController?.pushViewController(photoDetailVC, animated: true);
    }
    
    func addImageMark(_ latitude: Double, _ longitude: Double, title: String, id: Int){
        let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let photoPin = PhotoAnnotation(title: title, coordinate: coord, photoId: id) // use custom annotation to save photoId
        map.addAnnotation(photoPin)
    }
    
    func loadPhotoData(){
        getPhotosListAsync(completion: { photos in
            for photo in photos.results {
                getPhotoThumbnail(photo.thumbURL!, completion: { data in
                    self.imageData[String(photo.id)] = data // save image data to a dict, then use in map
                    self.addImageMark(photo.position.latitude, photo.position.longitude, title: photo.title, id: photo.id)
                })
            }
        })
    }
}
