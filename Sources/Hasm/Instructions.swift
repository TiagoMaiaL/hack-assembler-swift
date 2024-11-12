//
//  Instructions.swift
//  hasm
//
//  Created by Tiago Lopes on 09/11/24.
//

protocol Instruction {}

enum Instructions {
    struct Address: Instruction {
        let val: String
    }
    
    struct Computation: Instruction {
        let function: String
        let destination: String?
        let jump: String?
    }
    
    struct Symbol: Instruction {
        let name: String
    }
}
