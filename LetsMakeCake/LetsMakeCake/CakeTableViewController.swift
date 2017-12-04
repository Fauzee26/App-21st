//
//  CakeTableViewController.swift
//  LetsMakeCake
//
//  Created by Muhammad Hilmy Fauzi on 28/11/17.
//  Copyright © 2017 Hilmy Corp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CakeTableViewController: UITableViewController {
    
    var namaSelected:String?
    var bahanSelected:String?
    var caraSelected:String?

    var nampungId : String? = nil
    var arrayKue = [[String:String]]()


    override func viewDidLoad() {
        super.viewDidLoad()

        let params = ["id_pondok" : nampungId]
        let url = "http://localhost/Data/index.php/api/getKue"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler:
            { (response) in
                
                if response.result.isSuccess {
                    //kalau response suces kita ambil json
                    let json = JSON(response.result.value as Any)
                    print(json)
                    //get jsonaray dari json arrayq
                    self.arrayKue = json["List kue"].arrayObject as! [[String : String]]
                    //check d log
                    //check jumlah array
                    if (self.arrayKue.count > 0){
                        
                        //refresh tableview
                        self.tableView.reloadData()
                    }
                }else{
                    print("Error Server")
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayKue.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellKue", for: indexPath) as! CakeTableViewCell

        var serverid = arrayKue[indexPath.row]
        
        var namaPondok = serverid["nama_resep"]
        cell.lblNama.text = namaPondok

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row \(indexPath.row)selected")
        
        let task = arrayKue[indexPath.row]
        namaSelected = task["nama_resep"] as! String
        bahanSelected = task["bahan"] as! String
        caraSelected = task["cara"] as! String

        performSegue(withIdentifier: "passKue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "passKue" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! ViewController
                let value = arrayKue[indexPath.row]
                
                controller.passNama = value["nama_resep"] as! String
                controller.passBahan = value["bahan"] as! String
                controller.passCara = value["cara"] as! String
            }
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
