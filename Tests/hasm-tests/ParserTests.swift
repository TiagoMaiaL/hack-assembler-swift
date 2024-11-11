//
//  ParserTests.swift
//  hasm
//
//  Created by Tiago Lopes on 10/11/24.
//

import Testing
@testable import hasm

struct ParserTests {
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
            ["qwer;JMP"]
        ]
    )
    func testParsing(invalidLines lines: [String]) throws {
        #expect(throws: Parser.Error.self) {
            _ = try Parser().instructions(from: lines)
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
        let parser = Parser()

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
        let parser = Parser()

        let instructions = try parser.instructions(from: lines)
        
        #expect(!instructions.isEmpty)
        #expect(instructions.first is Instructions.Address)
        let aInstruction = instructions.first as? Instructions.Address
        #expect(aInstruction?.val == expectedVar)
    }
}
