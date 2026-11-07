//
//  AnimalVC.swift
//  SatApi
//
//  Created by comviva on 07/11/26.
//

import UIKit

class AnimalVC: UIViewController {

    
    @IBOutlet weak var animalsTableView: UITableView?
    let animalResource: AnimalResource = AnimalResource()
    var animals: [AnimalModel]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animalsTableView?.dataSource = self
        animalsTableView?.delegate = self
       
        let nib = UINib(nibName: "AnimalTableViewCell", bundle: nil)
        animalsTableView?.register(nib, forCellReuseIdentifier: "AnimalTableViewCell")
        animalResource.getAnimals { animal in
            self.animals = animal?.animals
           
            DispatchQueue.main.async { [weak self] in
                print("Trying to reload")
                self?.animalsTableView?.reloadData()
            }
           
        }
        
    }
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Animals List"
        
    }

}

extension AnimalVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.animals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTableViewCell") as! AnimalTableViewCell
        cell.animalNameLabel?.text = self.animals?[indexPath.row].name
        cell.animalNameLabel?.textColor = UIColor.red
      
        let animalImgStr = self.animals?[indexPath.row].image ?? ""
        let animalURL = URL(string: animalImgStr)!
      //  let animalImgData = (try? Data(contentsOf: animalURL)) ?? Data()
        cell.animalImgView?.loadImage(imageURL: animalURL, placeholder: "play")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
