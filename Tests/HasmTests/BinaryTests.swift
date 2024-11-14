//
//  BinaryTests.swift
//  hasm
//
//  Created by Tiago Lopes on 12/11/24.
//

@testable import Hasm
import Testing

struct BinaryTests {
    var labelTable = LabelTable()
    
    @Test(
        arguments: [
            (val: "0", bin: "0000000000000000"),
            (val: "1", bin: "0000000000000001"),
            (val: "2", bin: "0000000000000010"),
            (val: "3", bin: "0000000000000011"),
            (val: "4", bin: "0000000000000100"),
            (val: "5", bin: "0000000000000101"),
            (val: "6", bin: "0000000000000110"),
            (val: "7", bin: "0000000000000111"),
            (val: "8", bin: "0000000000001000"),
            (val: "9", bin: "0000000000001001"),
            (val: "22", bin: "0000000000010110"),
            (val: "155", bin: "0000000010011011"),
            (val: "781", bin: "0000001100001101"),
            (val: "7000", bin: "0001101101011000"),
        ]
    )
    mutating func testBinaryOfRegularAddressInstructions(
        testArguments: (val: String, bin: String)
    ) throws {
        let aInstruction = Instructions.Address(val: testArguments.val)
        #expect(try aInstruction.binaryRepresentation(using: &labelTable) == testArguments.bin)
    }
    
    @Test(
        arguments: [
            "1112444112241422",
            "    \t."
        ]
    )
    mutating func testBinaryTranslationOfAddressInstructionGeneratesError(val: String) {
        let aInstruction = Instructions.Address(val: val)
        #expect(throws: BinaryTranslationError.self) {
            try aInstruction.binaryRepresentation(using: &labelTable)
        }
    }
    
    typealias Computation = Instructions.Computation
    typealias CompTestArgument = (comp: Computation, bin: String)
    
    @Test(
        arguments: [
            (Computation(function: "D+1", destination: "M", jump: nil), "1110011111001000"),
            (Computation(function: "D+M", destination: "M", jump: nil), "1111000010001000"),
            (Computation(function: "A+1", destination: nil, jump: "JMP"), "1110110111000111"),
        ]
    )
    mutating func testBinaryTranslationOfComputationInstructions(argument: CompTestArgument) throws {
        #expect(try argument.comp.binaryRepresentation(using: &labelTable) == argument.bin)
    }
    
    @Test
    mutating func testBinaryTranslationOfAddressesWithVariables() throws {
        var labelTable = LabelTable()
        
        let address1 = Instructions.Address(val: "var1")
        #expect(try address1.binaryRepresentation(using: &labelTable) == "0000000000000000")
        
        let address2 = Instructions.Address(val: "var2")
        #expect(try address2.binaryRepresentation(using: &labelTable) == "0000000000000001")
        
        let address3 = Instructions.Address(val: "var3")
        #expect(try address3.binaryRepresentation(using: &labelTable) == "0000000000000010")
        
        let address4 = Instructions.Address(val: "var4")
        #expect(try address4.binaryRepresentation(using: &labelTable) == "0000000000000011")
    }
}
