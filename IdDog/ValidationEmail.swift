//
//  ValidationEmail.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 22/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import Foundation

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
    
}
