//
//  RegisterView.swift
//  ios_capstone
//
//  Created by Iulia on 2022/8/10.
//
/*
 Group INFO
 Jianxuan Li (8807952)
 Iulia Danilov (8816991)
 Krupa Suhagiya (8813230)
 Smit Mehta (8813480)
 Feng Zhou (8808141)
 Parshwa Shah (8836740)
 */
import UIKit

class RegisterView: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var errorMsg:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SignUp"
        self.errorMsg.text = ""
    }
    
    func checkAndDisplayError()->Bool{
        let fname = self.firstNameInput?.text ?? ""
        let lname = self.lastNameInput?.text ?? ""
        let email = self.emailInput?.text ?? ""
        let password = self.passwordInput?.text ?? ""
        
        if !fname.isEmpty && !lname.isEmpty && !email.isEmpty && !password.isEmpty{
            if(password.count >= 8){
                return true
            }else{
                errorMsg.text = "length must be 8 of the password"
                return false
            }
        }else{
            
            errorMsg.text = "Plese fill the all fields"
            return false
        }
    }
    

    @IBAction func register(_ sender: Any) {
        
        if(checkAndDisplayError() == false){
            return
        }
        
        let json: [String: Any] = ["email": emailInput.text!,
                                   "password": passwordInput.text!,
                                   "first_name": firstNameInput.text!,
                                   "last_name": lastNameInput.text!]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://capstone.freeyeti.net/api/account/signup/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    self.errorMsg.text = "Failed to create your account"
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                DispatchQueue.main.async {
                    self.errorMsg.text = "Account created"
                }
            }
            print(responseJSON ?? "No JSON data to show you! :(")
        }
        
        task.resume()
    }
}
