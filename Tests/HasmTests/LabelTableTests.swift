//
//  LabelTableTests.swift
//  Hasm
//
//  Created by Tiago Lopes on 13/11/24.
//

@testable import Hasm
import Testing

struct SymbolTableTests {
    var labelTable = LabelTable()
    
    @Test(
        arguments: [
            ("symbol1", 123),
            ("symbol2", 11),
            ("symbol3", 0),
            ("symbol4", 420),
            ("_someOjb$method", 800),
            ("___$$", 12),
        ]
    )
    mutating func testAssociating(symbol: String, toAddress: Int) {
        labelTable.associate(symbol: "symbol", to: 123)
        #expect(labelTable.address(for: "symbol") == 123)
    }
    
    @Test
    mutating func testAssociatingVariable() {
        labelTable.associate(variable: "someVariable")
        #expect(labelTable.address(for: "someVariable") == 0)
    }
    
    @Test
    mutating func testAssociatingSameVariableDoesNotUpdateAddres() {
        let variable = "var"
        
        labelTable.associate(variable: variable)
        #expect(labelTable.address(for: variable) == 0)
        
        labelTable.associate(variable: variable)
        #expect(labelTable.address(for: variable) == 0)
    }
    
    @Test
    func testGettingAddressOfUnassociatedVariable() {
        #expect(labelTable.address(for: "some variable") == nil)
    }
    
    @Test
    mutating func testAssociatingMultipleVariables() {
        for index in 0...50 {
            let variable = "var\(index)"
            let expectedAddress = index
            
            labelTable.associate(variable: variable)
            #expect(labelTable.address(for: variable) == expectedAddress)
        }
    }
    
    @Test(
        arguments: [
            ("SP", 0),
            ("LCL", 1),
            ("ARG", 2),
            ("THIS", 3),
            ("THAT", 4),
            ("R0", 0),
            ("R1", 1),
            ("R2", 2),
            ("R3", 3),
            ("R4", 4),
            ("R5", 5),
            ("R6", 6),
            ("R7", 7),
            ("R8", 8),
            ("R9", 9),
            ("R10", 10),
            ("R11", 11),
            ("R12", 12),
            ("R13", 13),
            ("R14", 14),
            ("R15", 15),
            ("SCREEN", 16384),
            ("KBD", 24576),
        ]
    )
    mutating func testAssociatingKeywords(keyword: String, expectedAddress: Int) {
        labelTable.associate(variable: keyword)
        #expect(labelTable.address(for: keyword) == expectedAddress)
    }
}
