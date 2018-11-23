//
//  Alert.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 22/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import Foundation
import UIKit

func alert(title: String, message: String) {

    let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let botaoOk = UIAlertAction(title: title, style: .default, handler: nil)

    alerta.addAction(botaoOk)
 

}


