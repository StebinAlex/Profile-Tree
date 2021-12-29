//
//  ViewController.swift
//  Tree
//
//  Created by Stebin Alex on 29/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let exp = ["Software Engineer - LTS (8 Months)", "Junior Software Engineer - Mobatia (1.6 Years)"].map{ TreeModel(name: $0, type: .child) }
        let edu = ["BE/CSE - BIOE", "+2 Science - GHSS Vithura", "SSLC - GHS Vithura"].map{ TreeModel(name: $0, type: .child) }
        let add = ["Bethel House Thallachira Memala P.O Vithura 695551, TVM "].map{ TreeModel(name: $0, type: .child) }
        let con = ["stebinalex96@gmail.com", "mail2stebin@gmail.com", "(+91) 7025640086"].map{ TreeModel(name: $0, type: .child) }
        let ski = ["UIKit & SwiftUI", "Swift & Objective C", "MVC & MVVM", "Core data & Realm", "Firebase & Firestore", "Github, Gitlab, Bitbucket & SVN", "RestAPI, SOAP & GraphQL", "SPM & Cocoa pod", "Auto Layout (Storyboard, Xib & Programatically)", "Photoshop", "MS Office"].map{ TreeModel(name: $0, type: .child) }
        
        let experience = TreeModel(name: "Experience", type: .sub, icon: #imageLiteral(resourceName: "footprint"), items: exp)
        let education = TreeModel(name: "Education", type: .sub, icon: #imageLiteral(resourceName: "alert"), selected: false, items: edu)
        let address = TreeModel(name: "Address", type: .sub, icon: #imageLiteral(resourceName: "placeholder"), items: add)
        let contacts = TreeModel(name: "Contacts", type: .sub, icon: #imageLiteral(resourceName: "smartphone"), items: con)
        let skills = TreeModel(name: "Skills", type: .sub, icon: #imageLiteral(resourceName: "mood"), items: ski)
        
        
        let treeData = TreeModel(name: "Stebin Alex", type: .main, icon: nil, selected: true, items: [experience, education, address, contacts, skills])
        
        
        let tree = TreeView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50))
        view.addSubview(tree)
        tree.setupData(treeData)
        view.backgroundColor = .white
    }


}

