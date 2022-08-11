//
//  PhotoDetail.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/6.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

struct WeatherData:Codable {
        let base: String
        let visibility: Int
        let dt: Int
    let weather: [Weather]
        let main: Main
        let timezone, id: Int
        let name: String
        let cod: Int
}
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}


class PhotoDetail: UIViewController {
    
    
    let urlApi = "https://api.openweathermap.org/data/2.5/weather?appid=debc05ab53796060495b9ab1f024be9e"


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
            
            // show the weather
            getWeatherData(lat: self.photo?.position.latitude ?? 0, lon: self.photo?.position.longitude ?? 0)
        }
    }
    
    func getWeatherData(lat: Double, lon: Double) {
        let urlSession = URLSession(configuration: .default)
        
        //pass Long and lat
        let url = URL(string: urlApi+"&lat="+String(lat) + "&lon="+String(lon))
        if let url = url {
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print(data)
                 //Decoding the data
                    let jsonDecoder = JSONDecoder()
                    do {
                        let readableData =   try jsonDecoder.decode(WeatherData.self, from: data)
                        
                        let weathers = readableData.weather
                        var icon = ""
                        var wMain = ""
                        for weather in weathers {
                           //Print on Console
                            print(weather.id )
                            print(weather.main )
                            icon = weather.icon
                            wMain = weather.main
                            break
                        }
                        DispatchQueue.main.async {
                            let imgUrl = URL(string: "https://openweathermap.org/img/wn/"+icon+"@2x.png")
                            let data = try? Data(contentsOf: imgUrl!)
                            self.icon.image = UIImage(data: data!)
                            self.weather.text = wMain
                            self.temp.text = "Temp : " + String(Int(readableData.main.temp - 273.15)) + "°"
                            print(data as Any)
                            }
                        
                    }
                    catch{
                        print("Not Able to get data ☹️")
                        
                    }
                }
            }
                        
            dataTask.resume()
        }
    }

    
}
