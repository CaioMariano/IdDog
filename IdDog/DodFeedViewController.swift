//
//  DodFeedViewController.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 22/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit
import AFNetworking

class DodFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Outlets
    
    @IBOutlet weak var dogsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dogsCollectionView: UICollectionView!
    
    
    //MARK: Propriedades
    
    var dogs: [String] = []
    
    var dogsType:String = "husky"
    
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dogsCollectionView.delegate = self
        self.dogsCollectionView.dataSource = self
        
    }
    //MARK: -ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        let logged : Int = defaultValues.integer(forKey: "ISLOGGEDIN") as Int
        if(logged != 1) {
            let domain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: domain!)
            
        } else {
            
            let task = requestDogs(husky: (dogsType))
            task.resume()
        }
        
    } // Fechamento ViewDidAppear
    
    //MARK: Actions
    
    @IBAction func segmentedDog(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.dogsType = "husky"
        case 1:
            self.dogsType = "hound"
        case 2:
            self.dogsType = "pug"
        case 3:
            self.dogsType = "labrador"
            
        default: self.dogsType = "husky"
        }
        let dogsRequest = requestDogs(husky: (dogsType))
        dogsRequest.resume()
    }
    
    //MARK: -Logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        performSegue(withIdentifier: "irTelaLogin", sender: self)
        
    }
    //MARK: Funcoes
    
    //Request
    func requestDogs(husky: String) -> URLSessionTask {
        
        let token:String = defaultValues.string(forKey: "token")!
        
        let listUrl = "https://api-iddog.idwall.co/feed?category=\(husky)"
        
        let headers = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        let url = URL(string: listUrl)!
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
       // print(dogs)
        return task
        
    } // Fechamento request
    
    //MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.dogsCollectionView.cellForItem(at: indexPath) as! DogsFeedCollectionViewCell
        let imageView = UIImageView(image: cell.dogImage.image)
        
        imageView.contentMode = .top
        imageView.backgroundColor = .darkGray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.frame = UIScreen.main.bounds
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
        
        self.view.addSubview(imageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    //MARK: - UICollectionView DataSource
    
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
            cell.dogImage.setImageWith(imageUrl!)
            
        }
        return cell
    }
    
}

