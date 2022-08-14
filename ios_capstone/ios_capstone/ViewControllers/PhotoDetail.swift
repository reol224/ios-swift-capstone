//
//  PhotoDetail.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/6.
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
import MapKit
import CoreLocation
import Foundation


class PhotoDetail: UIViewController {
    
    var photoId : Int? // receive photo id from map view
    var photo : Photo? // save photo info
    var photoData : Data? // save image data
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionMapView: MKMapView!
    @IBOutlet weak var temp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "Loading..."
        self.despLabel.text = ""

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
        DispatchQueue.main.async { [self] in
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
            
            // show the weather data on view
            self.showWeatherDetail(self.photo?.position.latitude ?? 0, self.photo?.position.longitude ?? 0)
        }
    }
    
    func showWeatherDetail(_ latitude: Double, _ longitude: Double){
        // show the weather
        getWeatherData(lat: latitude, lon: longitude, completion: {
            weather, temp in
            
            DispatchQueue.main.async {
                // if there is icon url
                if weather?.icon != nil {
                    let imgUrl = URL(string: "https://openweathermap.org/img/wn/" + weather!.icon + "@2x.png")
                    let data = try? Data(contentsOf: imgUrl!)
                    self.icon.image = UIImage(data: data!)
                }
                
                if weather?.main != nil && temp != nil {
                    self.weather.text = weather!.main
                    self.temp.text = "Temp : " + String(((temp! - 273.15) * 100).rounded() / 100) + "°"
                }
            }
        })
    }
}
