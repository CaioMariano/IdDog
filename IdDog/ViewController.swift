//
//  ViewController.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 22/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    //MARK: Propriedades
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        
        let email:String = textFieldEmail.text!
        
        if textFieldEmail.text != nil {
            
            if isValidEmail(testStr: email) == true {
                
                //MARK: Request
                
                let loginUrl = "https://api-iddog.idwall.co/signup?email=\(email)"
                
                let parameter:NSString = "email=\(email)" as NSString
                
                print("postData: %@", parameter) // Primeiro Print
                
                let url:NSURL = NSURL(string: loginUrl )!
                let postData = parameter.data(using: String.Encoding.utf8.rawValue)
                let postLength: NSString = String(postData!.count) as NSString
                let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
                
                request.httpMethod = "POST"
                request.httpBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = URLSession.shared.dataTask (with: request as URLRequest, completionHandler: {
                    (data, response, error) in
                    if (error != nil) {
                        print(error!)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!.statusCode)
                        
                        if let statusCode = httpResponse?.statusCode, 200..<300 ~= statusCode {
                            do {
                                let responseData: NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                
                                print(responseData) // print Response
                                
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                                
                                print(json) // print json
                                
                                let user:NSDictionary = (json!.value(forKey: "user") as? NSDictionary)!
                                
                                let token:NSString = user.value(forKey: "token") as! NSString
                                
                                print(token) // print token
                                
                                if (user.isEqual(user)) {
                                    
                                    let success = 1
                                    
                                    let defaultValues = UserDefaults.standard
                                    
                                    defaultValues.setValue(email, forKey: "email")
                                    defaultValues.setValue(token, forKey: "token")
                                    defaultValues.set(success, forKey: "ISLOGGEDIN")
                                    defaultValues.synchronize()
                                    
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    //DispatchQueue
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "irTela2", sender: nil)
                                    }
                                    
                                } else {
                                    print("Algo errado aconteceu")
                                }
                            }  catch {
                                print("Error")
                            }
                        }
                    }
                })
                task.resume()
                
                
            } else {
                
                let alerta = UIAlertController(title: "Alerta", message: "E-mail inválido", preferredStyle: .alert)
                
                let botaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alerta.addAction(botaoOk)
                
                present(alerta, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    //MARK: Funcoes
    
    
}

