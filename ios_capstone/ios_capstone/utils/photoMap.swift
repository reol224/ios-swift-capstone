//
//  PhotosMap.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/10.
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
import Foundation
import MapKit
import CoreLocation
import UIKit

// the annotation for the photos, can save photoId
class PhotoAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let photoId: Int
    
    init(title: String, coordinate: CLLocationCoordinate2D, photoId: Int) {
        self.title = title
        self.coordinate = coordinate
        self.photoId = photoId
   }
}

// resize the image aspect ration
// ref: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/
class PhotoUIImage : UIImage{
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
