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
                throw BinaryTranslationError.invalidAddress(value: val)
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
        "" // TODO:
    }
}

enum BinaryTranslationError: Error {
    case invalidAddress(value: String)
    case addressOutOfBounds(value: Int)
}
