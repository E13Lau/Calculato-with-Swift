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
    
    @IBAction func appandDigit(sender: UIButton) {
        let digit = sender.currentTitle!  //! 解包得到String
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit  //String 才能与 String 相加 "1"+"2" = "12"，去掉 ! 为 optional 类型，不能与 string 相加
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operand(sender: UIButton) {
        let operation = sender.currentTitle!
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        switch operation {
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "√": performOperation { sqrt($0) }
            default: break
        }
    }
    
    private func performOperation(operation: (Double,Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
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

