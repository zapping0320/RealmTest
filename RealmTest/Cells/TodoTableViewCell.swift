//
//  TodoTableViewCell.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/22.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
    }
    
}
