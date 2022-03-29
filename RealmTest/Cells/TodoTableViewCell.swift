//
//  TodoTableViewCell.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/22.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    public var enlargedImageAction:(() -> Void)?

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.isUserInteractionEnabled = true
        thumbImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enlargeImage)))
    }
    
    @objc func enlargeImage() {

        enlargedImageAction?()
    }
   
    
    func updateUI(_ record : Todo) {
        
        thumbImageView.image = UIImage(named: "PillDefault")
        
        titleLabel.text = record.title
        
        if record.isDone == true {
            statusLabel.text = "완료"
        }
        else {
            statusLabel.text = "하기 전"
        }
        
        
        if record.getImageName().isEmpty == false {
            guard let imageData = SaveImageHelper.loadImageFromDocumentDirectory(imageName: record.getImageName()) else { return }
            thumbImageView.image = imageData
        }
        
    }
    
}
