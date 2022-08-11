//
//  PhotoListTableView.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/11.
//

import UIKit

class PhotoListTableView: UITableViewController {
    
    @IBOutlet var table: UITableView!
    var photos : Photos?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photos"
        
        getPhotosListAsync(completion: { photos in
            self.photos = photos
            print("\(String(describing: self.photos?.count))")
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        })
    }
    
    //What to display in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell")!
        if (self.photos != nil){
            let photo = self.photos?.results[indexPath.row]
            cell.textLabel?.text = photo?.title
        }
        return cell
    }
    
    //How many rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    //How many sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Display section header
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return CanadaArray[section].Name
//    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
