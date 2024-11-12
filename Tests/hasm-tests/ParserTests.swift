//
//  ParserTests.swift
//  hasm
//
//  Created by Tiago Lopes on 10/11/24.
//

import Testing
@testable import hasm

struct ParserTests {
    let parser = Parser()
    
    @Test(
        arguments: [
            [""],
            ["   "],
            ["    \t"],
            ["asdfadsf"],
            ["@"],
            ["="],
            ["D="],
            ["=-1"],
            ["asdf="],
            ["=asdf"],
            ["afsdf=asdf"],
            ["aaa=A+1"],
            ["D=asdfsadf"],
            [";"],
            ["asdf;"],
            [";asdf"],
            ["A;"],
            [";JMP"],
            ["D;qwer"],
            ["qwer;JMP"],
            ["("],
            [")"],
            ["()"],
            ["(     )"],
            ["(    \t )"],
        ]
    )
    func testParsing(invalidLines lines: [String]) throws {
        #expect(throws: Parser.Error.self) {
            _ = try parser.instructions(from: lines)
        }
    }

    @Test(
        arguments: [
            ["@1"],
            ["@1123312"],
            ["@0"],
            ["@21"],
            ["@7"],
        ]
    )
    func testParsingValidAddresses(lines: [String]) throws {
        var expectedValue = lines[0]; expectedValue.removeFirst()

        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Address)
        let aInstruction = instructions.first as? Instructions.Address
        #expect(aInstruction?.val == expectedValue)
    }
    
    @Test(
        arguments: [
            ["@test"],
            ["@test$if"],
            ["@some_obj_test$if"],
        ]
    )
    func testParsingValidVariables(lines: [String]) throws {
        var expectedVar = lines[0]; expectedVar.removeFirst()

        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Address)
        let aInstruction = instructions.first as? Instructions.Address
        #expect(aInstruction?.val == expectedVar)
    }
    
    @Test(
        arguments: [
            ["A=A+1"],
            ["D=1"],
            ["AM=0"],
            ["M=-1"],
            ["M=D+M"],
            ["AMD=0"],
            ["D=D+M"],
            ["M=D+A"],
            ["M=D-A"],
            ["M=A-D"],
        ]
    )
    func testParsingValidAssignComputations(lines: [String]) throws {
        let expectedComputation = lines[0]
        let fields = expectedComputation.split(separator: "=").map(String.init)

        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Computation)
        let cInstruction = instructions.first as? Instructions.Computation
        #expect(cInstruction?.destination == fields[0])
        #expect(cInstruction?.function == fields[1])
    }
    
    @Test(
        arguments: [
            ["1;JMP"],
            ["-1;JMP"],
            ["D+M;JGT"],
            ["D;JLT"],
            ["M;JEQ"],
            ["D-M;JLE"],
            ["M;JNE"],
            ["A;JGE"],
        ]
    )
    func testParsingValidJumpComputations(lines: [String]) throws {
        let expectedComputation = lines[0]
        let fields = expectedComputation.split(separator: ";").map(String.init)

        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Computation)
        let cInstruction = instructions.first as? Instructions.Computation
        #expect(cInstruction?.function == fields[0])
        #expect(cInstruction?.jump == fields[1])
    }
    
    @Test(
        arguments: [
            ["(name)"],
            ["(symbol$endif)"],
            ["(symbol_some_marker)"]
        ]
    )
    func testParsingValidSymbols(lines: [String]) throws {
        var expectedName = lines[0]
        expectedName.removeAll { $0 == "(" || $0 == ")" }
        
        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Symbol)
        let symbol = instructions.first as? Instructions.Symbol
        #expect(symbol?.name == expectedName)
    }
}
