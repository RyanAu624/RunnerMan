//
//  StuHistTableViewController.swift
//  RunnerMan
//
//  Created by Hin on 16/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StuHistTableViewController: UITableViewController {

    let db = Firestore.firestore()
    var training = [Training]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecord()
        print(training)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getRecord(){
        let db = Firestore.firestore()
        
        db.collection("Training").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.training = snapshot.documents.map { d in
                        return Training(trainingID: d["Postid"] as? String ?? "",
                                        trainingMethod: d["Training Method"] as? String ?? "",
                                        trainingVideo: d["Video"] as? String ?? "",
                                        trainingDescription: d["description"] as? String ?? "",
                                        trainingDay: d["Train Day"] as? String ?? "",
                                        trainingStartTime: d["Start time"] as? String ?? "",
                                        trainingEndTime: d["End time"] as? String ?? "")
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return training.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StuHistcell

        cell.method.text = training[indexPath.row].trainingMethod
        cell.day.text = training[indexPath.row].trainingDay
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
