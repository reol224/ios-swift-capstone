//
//  request.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/5.
//

import Foundation

let PhotosAPI = "https://capstone.freeyeti.net/api/photos/?"

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
