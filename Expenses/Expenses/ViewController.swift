//
//  ViewController.swift
//  Expenses
//
//  Created by Mihai Costea on 09/12/14.
//  Copyright (c) 2014 Mihai Costea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UITableViewController, AddExpenseViewControllerDelegate {
    
    var expenses: [Expense]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestExpenses()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addExpense" {
            let addExpenseViewController = segue.destinationViewController as AddExpenseViewController
            addExpenseViewController.delegate = self
        }
    }

    // MARK:- UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("expenseCell", forIndexPath: indexPath) as UITableViewCell
        if self.expenses != nil {
            cell.textLabel?.text = self.expenses![indexPath.row].type
            cell.detailTextLabel?.text = "\(self.expenses![indexPath.row].amount)"
        }
        
        return cell
    }
    
    // MARK:- UITableViewDelegate
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let expenses = self.expenses {
            if editingStyle == .Delete {
                Alamofire.request(Router.DeleteExpense(expenses[indexPath.row].expenseId!)).responseSwiftyJSON({ (request, response, json, error) -> Void in
                    if error != nil {
                        println(error)
                        return
                    }
                    
                    self.requestExpenses()
                })
            }
        }
    }
    
    // MARK:- AddExpenseViewControllerDelegate
    
    func addExpenseViewController(addExpenseViewController: AddExpenseViewController, didCreateExpense expense: Expense) {
        addExpenseViewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.addExpense(expense)
    }
    
    // MARK:- Private

    private func requestExpenses() {
        Alamofire.request(Router.GetAll).responseSwiftyJSON { (request, response, json, error) -> Void in
            if (error != nil) {
                println(error)
                return
            }
            
            self.expenses = [Expense]()
            
            for item in json {
                if let expense = Expense.expenseFromJSON(item.1) {
                    self.expenses?.append(expense)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func addExpense(expense: Expense) {
        Alamofire.request(Router.CreateExpense(expense.toDictionary())).responseSwiftyJSON { (request, response, json, error) -> Void in
            if (error != nil) {
                println(error)
                return
            }
            
            self.requestExpenses()
        }
    }
    
    // MARK:- Actions
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
}

