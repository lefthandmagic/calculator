//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Loaner on 11/24/16.
//  Copyright © 2016 Praveen Murugesan. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0

    typealias PropertyList = AnyObject

    private var internalProgram = [AnyObject] ()

    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operand = op as? String {
                        performOperation(symbol: operand)
                    }
                }

            }
        }
    }

    private func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }

    private var pending: pendingBinaryOperationInfo?
    
    private var operations = ["π": Operation.Constant(M_PI),
                              "e": Operation.Constant(M_E),
                              "±": Operation.Unary({-$0}),
                              "√": Operation.Unary(sqrt),
                              "cos": Operation.Unary(cos),
                              "×": Operation.Binary({$0 * $1}),
                              "+": Operation.Binary({$0 + $1}),
                              "−": Operation.Binary({$0 - $1}),
                              "÷": Operation.Binary({$0 / $1}),
                              "=": Operation.Equals]
    
    private enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    func setOperand (operand : Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation (symbol : String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .Unary(let foo): accumulator = foo(accumulator)
            case .Binary(let foo):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: foo, op1: accumulator)
            case.Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.op1, accumulator)
            pending = nil
        }
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var op1: Double
    }
    
}
