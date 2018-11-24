//
//  UIResponder.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 24/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

extension ViewController {
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
}
