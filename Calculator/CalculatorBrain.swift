//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by command.Zi on 16/4/11.
//  Copyright © 2016年 command.Zi. All rights reserved.
//
//  operation 操作
//  symbol 符号
//  brain 脑
//  evaluate 评价、估值
//  Empty 空的
//  operand 运算对象
//  remainder 剩余的

import Foundation

class CalculatorBrain {
    
    //Printbacl protocol
    //Printbacl 已被重命名为 CustomStringConvertible
    private enum Op : CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperaion(String, (Double, Double) -> Double)
        
        //给类型添加一个 computed property（计算属性）
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperaion(let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    //() 就是在调用 initializer 方法
//    var opStack = Array<Op>() 等价
    private var opStack = [Op]()
    
//    var konwOps = Dictionary<String, Op>() 等价
    private var konwOps = [String:Op]()
    
    init() {
        //函数里面声明函数
        func learnOp(op: Op) {
            konwOps[op.description] = op
        }
        //等价
//        konwOps[""] = Op.BinaryOperaion("") {$0 * $1}
//        konwOps["×"] = Op.BinaryOperaion("×", {$0 * $1} )
        learnOp(Op.BinaryOperaion("×", * ))
        learnOp(Op.BinaryOperaion("÷", {$1 / $0} ))
        learnOp(Op.BinaryOperaion("+", {$0 + $1} ))
        konwOps["−"] = Op.BinaryOperaion("−", {$1 - $0} )
        konwOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(let ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            //错误信息：你不能在 ops 数组中移除最后一个元素，因为 ops 是不可变的
            //在你传递的参数前面，实际上隐含了一个 let
            //也可以改为 var
            //这里将 ops 拷贝给一个 var remainingOps
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                //这里 . 号，实际为 Op.Operand()，省略了Op
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                //递归
                let operandEvaluation = evaluate(remainingOps)
                if let opearnd = operandEvaluation.result {
                    return (operation(opearnd), operandEvaluation.remainingOps)
                }
            case .BinaryOperaion(_, let operation):
                let op1Evluation = evaluate(remainingOps)
                if let operand1 = op1Evluation.result {
                    let op2Evluation = evaluate(op1Evluation.remainingOps)
                    if let operand2 = op2Evluation.result {
                        return (operation(operand1, operand2), op2Evluation.remainingOps)
                    }
                }
            }
            //这里不写 default 是因为该 switch 已经处理完所有的分支，不需要写 default
        }
        return (nil, ops)
    }
    
    //有可能返回 nil，所以用 optional 作为返回值
    func evaluate() -> Double? {
        //可以直接使用 tuble
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    //symbol :符号
    func performOperation(symbol: String) -> Double? {
        //从字典取值，得到的是一个 Optional，因为有可能是空值
        if let operation = konwOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}