//
//  ViewController.swift
//  CodeDataSample
//
//  Created by Amol Tamboli on 08/06/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var tblData: UITableView!
    
    let database = DatabaseHandler.shared
    var users: [User]? {
        didSet{
            DispatchQueue.main.async {
                self.tblData.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  tblData.register(UITableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tblData.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.users = database.fetch(_type: User.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        APIHandler.shared.getData {
            self.users = self.database.fetch(_type: User.self)
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        guard let user = database.add(_type: User.self) else { return }
//        guard let name = txtName.text, let ageTxt = txtAge.text, let age = Int16(ageTxt) else { return }
//        user.name = name
//        user.age = age
//        user.createdAt = Date()
//        users?.append(user)
//        database.save()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.user = users?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath) {
        if editingStyle == .delete {
            guard let user = users?[indexPath.row] else { return }
            tblData.beginUpdates()
            self.database.delete(object: user)
            users?.remove(at: indexPath.row)
            tblData.deleteRows(at: [indexPath], with: .automatic)
            tblData.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var user: User? {
        didSet{
            setUpData()
        }
    }
    
    private func setUpData(){
        guard let user = user else { return }
        if let url = URL(string: user.avatar) {
            imgUser.kf.setImage(with: url)
            imgUser.layer.cornerRadius = imgUser.frame.height / 2
            imgUser.clipsToBounds = true
        }
        
        lblName.text = "\(user.first_name) \(user.last_name)"
        lblEmail.text = "\(user.email)"
    }
    
    override func prepareForReuse() {
        imgUser.image = nil
        lblName.text = nil
        lblEmail.text = nil
    }
}

