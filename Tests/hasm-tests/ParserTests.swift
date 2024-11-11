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

}
