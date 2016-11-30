//
//  ViewController.swift
//  Calculator
//
//  Created by Loaner on 11/23/16.
//  Copyright © 2016 Praveen Murugesan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsIntheMiddleOfTyping = false
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (userIsIntheMiddleOfTyping) {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsIntheMiddleOfTyping = true
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if (userIsIntheMiddleOfTyping) {
            brain.setOperand(operand: displayValue)
            userIsIntheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            displayValue = brain.result
        }
    }
    
}

