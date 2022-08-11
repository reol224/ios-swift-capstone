//
//  LoginView.swift
//  ios_capstone
//
//  Created by Iulia on 2022/8/10.
//

import UIKit

class LoginView: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        //reference https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
        
        let json: [String: Any] = ["email": username.text,
                                   "password": password.text]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://capstone.freeyeti.net/api/account/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {

                print(responseJSON)
            }
            print(responseJSON ?? "No JSON data to show you! :(")
        }

        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
