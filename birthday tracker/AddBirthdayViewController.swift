//
//  ViewController.swift
//  birthday tracker
//
//  Created by Анастасия Гаранович on 8/20/20.
//  Copyright © 2020 Анастасия Гаранович. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications



class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_sender: UIBarButtonItem) {
        print("Data saved")
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context:context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as NSDate? as Date?
        newBirthday.birthdayID = UUID().uuidString
        if let uniqueId = newBirthday.birthdayID {
            print("birthday ID: \(uniqueId)")
        }
        do {
            try context.save()
            let message = "Celebrating birthday today\(firstName) \(lastName)"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour = 0
            dateComponents.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        }
        catch let error {
            print("Failed to save due to error\(error)")
        }
        print("Name: \(newBirthday.firstName)")
        print("Surname: \(newBirthday.lastName)")
        print("Birthdate: \(newBirthday.birthdate)")
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
    }


}

