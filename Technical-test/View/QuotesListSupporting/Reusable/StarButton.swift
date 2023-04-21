//
//  StarButton.swift
//  Technical-test
//
//  Created by Maksym Balukhtin on 18.04.2023.
//

import UIKit

class StarButton: UIButton {
    var isActive: Bool = false {
        willSet {
            setImage(UIImage(named: newValue ? "favorite" : "no-favorite"), for: [])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "no-favorite"), for: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
