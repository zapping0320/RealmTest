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
        
        enlargedImageView.image = UIImage(named: enlargedImagePath)
        
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
