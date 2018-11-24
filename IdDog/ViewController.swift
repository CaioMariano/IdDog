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
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    //MARK: Propriedades
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmail.layer.cornerRadius = 20
        buttonLogin.layer.cornerRadius = 20
        
    }
    
    //MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        
        let email:String = textFieldEmail.text!
        
        if textFieldEmail.text != nil {
            
            if isValidEmail(testStr: email) == true {
                
                //MARK: -Request
                
                let loginUrl = "https://api-iddog.idwall.co/signup?email=\(email)"
                
                let parameter:NSString = "email= \(email)" as NSString
                
                print("postData:", parameter)
                
                let url:NSURL = NSURL(string: loginUrl )!
                let postData = parameter.data(using: String.Encoding.utf8.rawValue)
                let postLength: NSString = String(postData!.count) as NSString
                let requestlogin:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
                
                requestlogin.httpMethod = "POST"
                requestlogin.httpBody = postData
                requestlogin.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                requestlogin.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                requestlogin.setValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = URLSession.shared.dataTask (with: requestlogin as URLRequest, completionHandler: {
                    (data, response, error) in
                    if (error != nil) {
                        print(error!)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!.statusCode)
                        
                        if let statusCode = httpResponse?.statusCode, 200..<300 ~= statusCode {
                            do {
                                let responseData: NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                
                                //print(responseData)
                                
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                                
                                //print(json)
                                
                                let user:NSDictionary = (json!.value(forKey: "user") as? NSDictionary)!
                                
                                let token:NSString = user.value(forKey: "token") as! NSString
                                
                                //print(token)
                                
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
                                    print("\(error?.localizedDescription)")
                                }
                            }  catch {
                                print("Error")
                            }
                        }
                    }
                })
                task.resume()
                
            } else {
                
               self.alert(message: "E-mail inválido", title: "Alerta")
            }
        }
    }
}

