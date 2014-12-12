//
//  AddExpenseViewController.swift
//  Expenses
//
//  Created by Mihai Costea on 09/12/14.
//  Copyright (c) 2014 Mihai Costea. All rights reserved.
//

import UIKit

protocol AddExpenseViewControllerDelegate {
    func addExpenseViewController(addExpenseViewController: AddExpenseViewController, didCreateExpense expense: Expense)
}

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var delegate: AddExpenseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonPressed(sender: UIButton) {
        if (!self.typeTextField.text.isEmpty && !self.amountTextField.text.isEmpty) {
            let numberFormatter = NSNumberFormatter()
            if let amount = numberFormatter.numberFromString(self.amountTextField.text) {
                let expense = Expense(expenseId: nil, amount: Float(amount), type: self.typeTextField.text, date: NSDate())
                self.delegate?.addExpenseViewController(self, didCreateExpense: expense)
            }
        }
    }
}
