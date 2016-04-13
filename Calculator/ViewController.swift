//
//  ViewController.swift
//  Calculator
//
//  Created by command.Zi on 16/3/6.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false //var is property
    
    var brain = CalculatorBrain()
    
    @IBAction func appandDigit(sender: UIButton) {
        let digit = sender.currentTitle!  //! 解包得到String
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit  //String 才能与 String 相加 "1"+"2" = "12"，去掉 ! 为 optional 类型，不能与 string 相加
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            //～～～～～
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

