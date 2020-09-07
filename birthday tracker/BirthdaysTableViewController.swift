//
//  BirthdaysTableViewController.swift
//  birthday tracker
//
//  Created by Анастасия Гаранович on 8/28/20.
//  Copyright © 2020 Анастасия Гаранович. All rights reserved.
//

import UIKit
import CoreData



class BirthdaysTableViewController: UITableViewController {
    func addBirthdayViewController(_ addBirthdayViewController: AddBirthdayViewController, didAddBirthdayViewController birthday: Birthday) {
        birthdays.append(birthday)
        tableView.reloadData()
    }
    
    
    var birthdays = [Birthday]()
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor1]
        do {
            birthdays = try context.fetch(fetchRequest)
        }
        catch let error {
            print("Failed to download due to error\(error)")
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for:indexPath)
        let birthday = birthdays[indexPath.row]
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        else {
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    
    override func tableView(_ tableView:UITableView, canEditRowAt indexPath: IndexPath) ->Bool {
        return true
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath) {
        if birthdays.count > indexPath.row {
            let birthday = birthdays[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday)
            birthdays.remove(at: indexPath.row)
            do {
                try context.save()
            }
            catch let error {
                print("Failed to save due to error\(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
