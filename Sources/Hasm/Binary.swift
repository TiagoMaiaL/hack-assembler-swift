//
//  Binary.swift
//  hasm
//
//  Created by Tiago Lopes on 12/11/24.
//

protocol BinaryRepresentable: Instruction {
    var binaryRepresentation: String { get throws }
}

extension Instructions.Address: BinaryRepresentable {
    var binaryRepresentation: String {
        get throws {
            // TODO: if this is a name, get its corresponding address.
            guard let memoryAddress = Int(val) else {
                throw BinaryTranslationError.invalid(address: val)
            }
            
            return try computeBinary(of: memoryAddress)
        }
    }
    
    private func computeBinary(of number: Int) throws -> String {
        var number = number
        var reminder = 0
        var binary = ""
        
        while number > 0 {
            reminder = number % 2
            number = number / 2
            binary.insert(
                reminder == 0 ? "0" : "1",
                at: binary.startIndex
            )
        }
        
        let wordSize = 16
        
        guard binary.count <= wordSize - 1 else {
            throw BinaryTranslationError.addressOutOfBounds(value: number)
        }

        let padAmount = wordSize - binary.count
        
        for _ in 0 ..< padAmount {
            binary.insert("0", at: binary.startIndex)
        }
        
        return binary
    }
}

extension Instructions.Computation: BinaryRepresentable {
    var binaryRepresentation: String {
        get throws {
            let header = "111"
            let a = function.contains("M") ? "1" : "0"
            let comp = try compField(from: function)
            let dest = try destField(from: destination)
            let jump = try jumpField(from: jump)
            
            return header + a + comp + dest + jump
        }
    }
    
    private func compField(from function: String) throws -> String {
        switch function {
        case "0": return "101010"
        case "1": return "111111"
        case "-1": return "111010"
        case "D": return "001100"
        case "A", "M": return "110000"
        case "!D": return "001101"
        case "!A", "!M": return "110001"
        case "-D": return "001111"
        case "-A", "-M": return "110011"
        case "D+1": return "011111"
        case "A+1", "M+1": return "110111"
        case "D-1": return "001110"
        case "A-1", "M-1": return "110010"
        case "D+A", "D+M": return "000010"
        case "D-A", "D-M": return "010011"
        case "A-D", "M-D": return "000111"
        case "D&A", "D&M": return "000000"
        case "D|A", "D|M": return "010101"
        default: throw BinaryTranslationError.invalid(function: function)
        }
    }
    
    private func destField(from destination: String?) throws -> String {
        guard let destination else { return "000" }
        
        switch destination {
        case "M": return "001"
        case "D": return "010"
        case "MD": return "011"
        case "A": return "100"
        case "AM": return "101"
        case "AD": return "110"
        case "AMD": return "111"
        default: throw BinaryTranslationError.invalid(destination: destination)
        }
    }
    
    private func jumpField(from jump: String?) throws -> String {
        guard let jump else { return "000" }
        
        switch jump {
        case "JGT": return "001"
        case "JEQ": return "010"
        case "JGE": return "011"
        case "JLT": return "100"
        case "JNE": return "101"
        case "JLE": return "110"
        case "JMP": return "111"
        default: throw BinaryTranslationError.invalid(jump: jump)
        }
    }
}

enum BinaryTranslationError: Error {
    case invalid(address: String)
    case addressOutOfBounds(value: Int)
    case invalid(function: String)
    case invalid(destination: String)
    case invalid(jump: String)
}
