//
//  PhotoListCell.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/11.
//

import UIKit

class PhotoListCell: UITableViewCell {

    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadData(photo: Photo){
        print("----> \(photo.id)")
        photoTitleLabel.text = photo.title
        getPhotoThumbnail(photo.thumbURL!, completion: { data in
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        })
    }
}
