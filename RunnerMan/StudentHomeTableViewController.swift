//
//  StudentHomeTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/2/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StudentHomeTableViewController: UITableViewController, UICollectionViewDataSource {
    
    var target = [Target]()
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var collectionView: UICollectionView!
    var banner = HeroBanner.fetchBanner()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStuTarget()
        self.tableView.reloadData()
        self.tableView.separatorStyle = .none
        collectionView.dataSource = self
//        getWeather()
    }
    
    @IBAction func addTargetClicked(_ sender: Any) {
        showAlertController()
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Post", message: "Let's setup a new task.", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = UIKeyboardType.phonePad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
            let targetInput = alertController.textFields?[0].text
            //Check user input
            //If user input equal to null the data will not save to firestore
            if targetInput != "" {
                self.saveTargetDataToFirestore(targetInput!)
            }
         }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveTargetDataToFirestore(_ targetInput:String) {
        let ref = db.collection("student").document(uID!).collection("targetList")
                
        ref.document(targetInput).setData(["target":targetInput,
                                "mark":false])
        
        getStuTarget()
    }
    
    func getStuTarget() {
        let ref = db.collection("student").document(uID!).collection("targetList")
        
        ref.getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.target = snapshot.documents.map{ d in
                        return Target(target: d["target"] as? String ?? "",
                                      mark: d["mark"] as! Bool)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StuWeatherCell", for: indexPath) as! StudentHomeCollectionViewCell
        let banner = banner[indexPath.item]
        cell.heroBanner = banner
        return cell
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return target.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell", for: indexPath) as! TargetCell
        cell.taskLabel.text = target[indexPath.row].target
        if target[indexPath.row].mark == false {
            cell.markCheck.image = UIImage(named: "unmark")
        } else {
            cell.markCheck.image = UIImage(named: "marked")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //remove data
            let removedTarget = target.remove(at: indexPath.row)
            
            let ref = db.collection("student").document(uID!).collection("targetList")
            ref.document(removedTarget.target).delete()
            //remote table cell
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TargetCell else { return }
        
        if target[indexPath.row].mark == false {
            //Update target condition
            let ref = db.collection("student").document(uID!).collection("targetList")
            ref.document(target[indexPath.row].target).updateData(["mark":true])
            target[indexPath.row].mark = true
            cell.markCheck.image = UIImage(named: "marked")
        } else {
            let ref = db.collection("student").document(uID!).collection("targetList")
            ref.document(target[indexPath.row].target).updateData(["mark":false])
            target[indexPath.row].mark = false
            cell.markCheck.image = UIImage(named: "unmark")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "studentLoginPage") {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeather() {
        
        if let url = URL(string: "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
//                data?.prettyPrintedJSONString()
                let decoder = JSONDecoder()
                if let weatherInfo = try? decoder.decode(WeatherInfo.self, from: data!){
                    print("\(weatherInfo.temperature.data)")
                }
                
            }.resume()
        }
    }
    
}

//// MARK: - collection view data source
//
//extension StudentHomeCollectionViewCell: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StuWeatherCell", for: indexPath) as! StudentHomeCollectionViewCell
//        let banner = banner[indexPath.item]
//        cell.banner = banner
//        return cell
//    }
//}

class WeatherInfo : Codable {
    var temperature : Temperature
}
class Temperature : Codable {
    var data : [TempRecord]
}
class TempRecord : Codable {
    var place : String
    var value : Double
    var unit  : String
}
//
//extension Data {
//
//    func prettyPrintedJSONString() {
//        guard
//            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
//            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
//            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
//                print("Failed to read JSON Object.")
//                return
//        }
//        print(prettyJSONString)
//    }
//}
