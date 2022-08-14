//
//  request.swift
//  ios_capstone
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
//  Created by Jack on 2022/8/5.
//

import Foundation

// photos api
let PhotosAPI = "https://capstone.freeyeti.net/api/photos/?"

//api from openweather
let WeatherAPI = "https://api.openweathermap.org/data/2.5/weather?appid=debc05ab53796060495b9ab1f024be9e"

// get the photos list
func getPhotosListAsync(completion: @escaping(Photos) -> Void){
    guard let url = URL(string: PhotosAPI) else {
        return
    }

    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let photos = try? JSONDecoder().decode(Photos.self, from: data) {
                completion(photos)
            } else {
                print("Invalid Response")
            }
        } else if let error = error {
            print("HTTP Request Failed \(error)")
        }
    }
    
    task.resume()
}

// get the image of photo
func getPhotoThumbnail(_ thumbUrl: String, completion: @escaping(Data) -> Void){
    guard let url = URL(string: thumbUrl) else {
        return
    }

    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            completion(data)
        } else if let error = error {
            print("HTTP Request Failed \(error)")
        }
    }
    task.resume()
}

// get detail by photo id
func getPhotoDetailAsync(id: Int, completion: @escaping(Photo) -> Void){
    guard let url = URL(string: "https://capstone.freeyeti.net/api/photos/\(id)/") else {
        return
    }

    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let photo = try? JSONDecoder().decode(Photo.self, from: data) {
                completion(photo)
            } else {
                print("Invalid Response")
            }
        } else if let error = error {
            print("HTTP Request Failed \(error)")
        }
    }
    
    task.resume()
}

// fetch weather info using the given location
func getWeatherData(lat: Double, lon: Double, completion: @escaping(Weather?, Double?) -> Void) {
    let urlSession = URLSession(configuration: .default)
    
    //pass Long and lat
    let url = URL(string: WeatherAPI + "&lat=" + String(lat) + "&lon=" + String(lon))
    if let url = url {
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print(data)
                //Decoding the data
                let jsonDecoder = JSONDecoder()
                do {
                    let readableData =   try jsonDecoder.decode(WeatherData.self, from: data)
                    let weathers = readableData.weather
                    if let weather = weathers.first {
                        completion(weather, readableData.main.temp)
                    }else{
                        completion(nil, nil)
                    }
                }
                catch{
                    print("Not Able to get data ☹️")
                    completion(nil, nil) // return nil if error
                }
            }
        }
        
        dataTask.resume()
    }
}
