//
//  DodFeedViewController.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 22/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

    class DodFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
        //MARK: Outlets
        
        @IBOutlet weak var dogsSegmentedControl: UISegmentedControl!
        
        
        @IBOutlet weak var dogsCollectionView: UICollectionView!
        
        
        //MARK: Propriedades
        
        var dogs: [String] = []
        
        var husky:String = "husky"
        
        let defaultValues = UserDefaults.standard
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.dogsCollectionView.delegate = self
            self.dogsCollectionView.dataSource = self
            
        }
        // ViewDidAppear
        override func viewDidAppear(_ animated: Bool) {
            
            super.viewDidAppear(true)
            let LoggedIn:Int = defaultValues.integer(forKey: "ISLOGGEDIN") as Int
            if(LoggedIn != 1) {
                let appDomain = Bundle.main.bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                performSegue(withIdentifier: "Login", sender: self)
                
            } else {
                
                let task = loadRequest(husky: (husky))
                task.resume()
            }
            
        } // Fechamento ViewDidAppear
        
        //MARK: Actions
        
        @IBAction func segmentedDog(_ sender: UISegmentedControl) {
            
            switch sender.selectedSegmentIndex {
            case 0:
                self.husky = "husky"
            case 1:
                self.husky = "hound"
            case 2:
                self.husky = "pug"
            case 3:
                self.husky = "labrador"
                
            default: self.husky = "husky"
            }
            let task = loadRequest(husky: (husky))
            task.resume()
        }
        
        //MARK: Funcoes
        
        func loadRequest(husky: String) -> URLSessionTask {
            
            let tokenregis:String = defaultValues.string(forKey: "token")!
            
            let LIST_URL = "https://api-iddog.idwall.co/feed?category=\(husky)"
            
            let headers = [
                "Authorization": tokenregis,
                "Content-Type": "application/json"
            ]
            let url = URL(string: LIST_URL)!
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        self.dogs = (dataDictionary["list"] as! [String])
                        self.dogsCollectionView.reloadData()
                    }
                }
                else {
                    print("Erro")
                }
            }
            print(dogs)
            return task
            
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return self.dogs.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogsFeedCollectionViewCell
            let dog = self.dogs[indexPath.row]
            if let posterPath = dog as? String {
                let imageUrl = URL(string: posterPath)
                //cell.dogImage.kf.setImageWith(imageUrl!)
                
            }
            
            return cell
        }

}
