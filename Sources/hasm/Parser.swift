//
//  Parser.swift
//  hasm
//
//  Created by Tiago Lopes on 09/11/24.
//

struct Parser {
    func instructions(from lines: [String]) throws -> [Instruction] {
        return try lines.map(parse)
    }
    
    private func parse(_ line: String) throws -> Instruction {
        guard let char = line.first else {
            // TODO: Define and throw error
            fatalError()
        }
        
        switch char {
        case "@":
            return try parseAddress(line)
        
        case "(":
            return try parseSymbol(line)
            
        default:
            return try parseComputation(line)
        }
    }
    
    private func parseAddress(_ line: String) throws -> Instruction {
        guard line.count >= 2 else { // Accounts for @ sign
            // TODO: Define and throw error
            fatalError()
        }
        
        let val = String(line[line.startIndex...])
        try validate(addressOrVariable: val)
        return Instructions.Address(
            val: val
        )
    }
    
    private func parseComputation(_ line: String) throws -> Instruction {
        let function: String
        let destination: String?
        let jump: String?
        
        if let equalsIndex = line.firstIndex(of: "=") {
            destination = String(line[..<equalsIndex])
            function = String(line[equalsIndex...])
            jump = nil

        } else if let semicolonIndex = line.firstIndex(of: ";") {
            destination = nil
            function = String(line[..<semicolonIndex])
            jump = String(line[semicolonIndex...])
            
        } else {
            // TODO: Define and throw an error
            fatalError()
        }
        
        try validate(function: function)
        if let destination { try validate(destination: destination) }
        if let jump { try validate(jump: jump) }
        
        return Instructions.Computation(
            function: function,
            destination: destination,
            jump: jump
        )
    }
    
    private func parseSymbol(_ line: String) throws -> Instruction {
        guard line[line.startIndex] == "(" && line[line.endIndex] == ")" else {
            // TODO: define and throw error
            fatalError()
        }
        
        var symbol = line
        symbol.remove(at: line.startIndex)
        symbol.remove(at: line.endIndex)
        
        try validate(symbol: symbol)
        
        return Instructions.Symbol(
            name: symbol
        )
    }
}

extension Parser {
    private func validate(addressOrVariable: String) throws {
        guard addressOrVariable.isValidAddress ||
              addressOrVariable.isValidSymbol else {
             // TODO: Define and throw error
            fatalError()
        }
    }
    
    private func validate(destination: String) throws {
        switch destination {
        case "A": break
        case "D": break
        case "M": break
        case "AM": break
        case "AD": break
        case "MD": break
        case "ADM": break
        default: fatalError() // TODO: Define and throw an error
        }
    }
    
    private func validate(jump: String) throws {
        switch jump {
        case "JGT": break
        case "JEQ": break
        case "JGE": break
        case "JLT": break
        case "JNE": break
        case "JLE": break
        case "JMP": break
        default: fatalError() // TODO: Define and throw an error
        }
    }
    
    private func validate(function: String) throws {
        switch function {
        case "0": break
        case "1": break
        case "-1": break
        case "D": break
        case "A": break
        case "!D": break
        case "!A": break
        case "-D": break
        case "-A": break
        case "D+1": break
        case "A+1": break
        case "D-1": break
        case "A-1": break
        case "D+A": break
        case "D-A": break
        case "A-D": break
        case "D&A": break
        case "D|A": break
        case "M": break
        case "!M": break
        case "-M": break
        case "M+1": break
        case "M-1": break
        case "D+M": break
        case "D-M": break
        case "M-D": break
        case "D&M": break
        case "D|M": break
        default: fatalError() // TODO: Define and throw an error
        }
    }
    
    private func validate(symbol: String) throws {
        guard symbol.isValidSymbol else {
            // TODO: Define and throw error
            fatalError()
        }
    }
}

private extension String {
    var isValidSymbol: Bool {
        (first?.isLetter ?? false) && allSatisfy { char in
            return char.isNumber ||
                   char.isLetter ||
                   char == "."   ||
                   char == "$"   ||
                   char == "_"
        }
    }
    
    var isValidAddress: Bool {
        allSatisfy(\.isNumber)
    }
}
