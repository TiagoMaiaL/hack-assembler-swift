//
//  LabelTable.swift
//  Hasm
//
//  Created by Tiago Lopes on 13/11/24.
//

struct LabelTable {
    typealias Label = String
    typealias Address = Int
    private var addressMap: [Label: Address] = [:]
    
    private var nextAvailableAddress = 0
    
    mutating func associate(symbol: Label, to address: Address) {
        guard address >= 0 else {
            preconditionFailure("Address can't be negative")
        }
        addressMap[symbol] = address
    }
    
    mutating func associate(variable: Label) {
        guard PredefinedVariables(rawValue: variable.lowercased()) == nil else {
            return
        }
        
        guard address(for: variable) == nil else {
            return
        }
        
        addressMap[variable] = nextAvailableAddress
        nextAvailableAddress += 1
    }
    
    func address(for label: Label) -> Address? {
        return if let predefinedVar = PredefinedVariables(rawValue: label.lowercased()) {
            predefinedVar.address
        } else {
            addressMap[label]
        }
    }
}

private extension LabelTable {
    enum PredefinedVariables: String {
        case sp
        case lcl
        case arg
        case this
        case that
        case r0
        case r1
        case r2
        case r3
        case r4
        case r5
        case r6
        case r7
        case r8
        case r9
        case r10
        case r11
        case r12
        case r13
        case r14
        case r15
        case screen
        case kbd
        
        var label: Label {
            rawValue.uppercased()
        }
        
        var address: Address {
            switch self {
            case .sp: 0
            case .lcl: 1
            case .arg: 2
            case .this: 3
            case .that: 4
            case .r0: 0
            case .r1: 1
            case .r2: 2
            case .r3: 3
            case .r4: 4
            case .r5: 5
            case .r6: 6
            case .r7: 7
            case .r8: 8
            case .r9: 9
            case .r10: 10
            case .r11: 11
            case .r12: 12
            case .r13: 13
            case .r14: 14
            case .r15: 15
            case .screen: 16384
            case .kbd: 24576
            }
        }
    }
}
