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
        
        for char in val {
            // TODO: define the possible kinds of chars here.
            guard char.isNumber || char.isLetter else {
                // TODO: Define and throw error.
                fatalError()
            }
        }

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
            // TODO: Validate left and right sides

        } else if let semicolonIndex = line.firstIndex(of: ";") {
            destination = nil
            function = String(line[..<semicolonIndex])
            jump = String(line[semicolonIndex...])
            // TODO: Validate left and right sides
            
        } else {
            // TODO: Define and throw an error
            fatalError()
        }
        
        return Instructions.Computation(
            function: function,
            destination: destination,
            jump: jump
        )
    }
    
    private func parseSymbol(_ line: String) throws -> Instruction {
        // TODO: Validate start and index are ( and )
        // TODO: Validate symbol contains valid chars
        var line = line
        line.remove(at: line.startIndex)
        line.remove(at: line.endIndex)
        
        return Instructions.Symbol(
            name: line
        )
    }
}
