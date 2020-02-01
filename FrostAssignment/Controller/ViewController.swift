//
//  ViewController.swift
//  FrostAssignment
//
//  Created by Chandrasekhar K on 31/01/20.
//  Copyright © 2020 Chandrasekhar K. All rights reserved.
//

import UIKit
import CoreData




class ViewController: UIViewController {
    
    
    
    
    
    
    @IBOutlet weak var tableviewObj: UITableView!
    @IBOutlet weak var searchBarObj: UISearchBar!
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    var notes: [NSManagedObject] = []
    
    
    // MARK: - View life cycle starts from here
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Note List"
        // setting searchBar delegate programatically
        searchBarObj.delegate = self
        // calling fetchCoreData function
        fetchCoreData()
    }
    
    // MARK: - fetching from coredata
    func fetchCoreData(){
        // calling searchNotesList function from Repository
        CoreDataRepository().getNotesList {[weak self] (result) in
            switch result{
            case .failure(let err):
                print(err)
            // show alert
            case .success(let dat):
                self?.notes = dat
                self?.tableviewObj.reloadData()
            }
        }
    }
    
    // MARK: - Adding note button action
    @IBAction func AddNote(_ sender: UIBarButtonItem) {
        
        let myvc = self.storyboard?.instantiateViewController(withIdentifier: "AddVC") as! AddVC
        myvc.modalPresentationStyle = .overCurrentContext
        myvc.onDoneBlock = {[weak self] result in
            // calling fetchCoreData function
            self?.fetchCoreData()
        }
        present(myvc, animated: true, completion: nil)
    }
    
    // MARK: - Adding Sorted button action
    @IBAction func SortByAction(_ sender: UIBarButtonItem) {
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Jan - Dec", style: .default) { [weak self] action -> Void in
            
            print("First Action pressed")
            self?.SortedBy(isAscending: true, key: "date")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Dec - Jan", style: .default) { [weak self] action ->  Void in
            
            print("Second Action pressed")
            self?.SortedBy(isAscending: false, key: "date")
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "name", style: .default) { [weak self] action ->  Void in
            
            print("Second Action pressed")
            self?.SortedBy(isAscending: true, key: "title")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil) 
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
        
        
        // present an actionSheet...
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // MARK: - sorting by Date&&Name from coredata
    func SortedBy(isAscending:Bool,key:String) {
        CoreDataRepository().sortlistDate(key: key, isAscending: isAscending) {[weak self] (result) in
            switch result{
            case .failure(let err):
                print(err)
            // show alert
            case .success(let dat):
                print(dat)
                self?.notes = dat
                self?.tableviewObj.reloadData()
            }
        }
    }
    
    deinit {
        print("delocted viewcontroller")
    }
    
}

// MARK: - implimenting for tableview delegate && datasource methods
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.selectionStyle = .none
        cell.configureWithItem(item: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // calling searchNotesList function from Repository
            CoreDataRepository().deleteNotes(notes[indexPath.row]) {[weak self] (result) in
                switch result{
                case .failure(let err):
                    print(err)
                case .success(let dat):
                    self?.notes = dat
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.tableviewObj.reloadData()
                }
            }
            
        }
    }
}

// MARK: - implimenting searchBar delegate methods
extension ViewController:UISearchBarDelegate,UISearchDisplayDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText != "" {
            // calling searchNotesList function from Repository
            CoreDataRepository().searchNotesList(searchText) {[weak self] (result) in
                switch result{
                case .failure(let err):
                    print(err)
                case .success(let dat):
                    print(dat)
                    self?.notes = dat
                }
            }
        }else{
            // calling fetchCoreData function again
            fetchCoreData()
        }
        tableviewObj.reloadData()
    }
}

