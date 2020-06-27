//
//  ViewController.swift
//  Project1
//
//  Created by Robert Silverman on 5/8/20.
//  Copyright © 2020 Robert Silverman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let defaults = UserDefaults.standard
            if let loadedPictures = defaults.object(forKey: "pictures") as? Data {
                let jDecoder = JSONDecoder()
                
                do {
                    self.pictures = try jDecoder.decode([Picture].self, from: loadedPictures)
                } catch {
                    print("Cannot load data")
                }
            } else {
                let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        //This is a storm image
                        let picture = Picture(name: item)
                        self.pictures.append(picture)
                    }
                }
                
            }
            self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].fileName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pictures[indexPath.row].lookCount += 1
        save()
        print("\(pictures[indexPath.row].fileName) views: \(pictures[indexPath.row].lookCount)")
        
        if let vc = storyboard?.instantiateViewController(identifier: "Broken") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].fileName
            vc.selectedLocation = indexPath.row + 1
            vc.totalImages = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Please download StormViewer"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let jEncoder = JSONEncoder()
        if let jsonData = try? jEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(jsonData, forKey: "pictures")
        } else {
            print("Failed to save Pictures as JSON data")
        }
    }


}

