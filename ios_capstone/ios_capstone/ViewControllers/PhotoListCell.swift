//
//  PhotoListCell.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/11.
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

class PhotoListCell: UITableViewCell {

    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadData(photo: Photo){
        photoTitleLabel.text = photo.title
        getPhotoThumbnail(photo.thumbURL!, completion: { data in
            DispatchQueue.main.async {
                let image = PhotoUIImage(data: data)
                let scaledImage = image!.scalePreservingAspectRatio(
                    targetSize: CGSize(width: 420, height: 240)
                )
                self.photoImageView.image = scaledImage
            }
        })
    }
}
