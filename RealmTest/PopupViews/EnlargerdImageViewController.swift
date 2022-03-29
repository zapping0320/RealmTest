//
//  EnlargerdImageViewController.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/29.
//

import UIKit

class EnlargerdImageViewController: UIViewController {
    
    @IBOutlet weak var enlargedImageView: UIImageView!
    
    public var imagePath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let enlargedImagePath =  imagePath  else {
            return
        }
        
        guard let imageData = SaveImageHelper.loadImageFromDocumentDirectory(imageName: enlargedImagePath) else { return closeVC() }
        enlargedImageView.image = imageData
        
    }

    @IBAction func closeAction(_ sender: Any) {
        closeVC()
    }
    
    private func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }

}
