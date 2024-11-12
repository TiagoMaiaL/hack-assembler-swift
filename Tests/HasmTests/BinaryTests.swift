//
//  BinaryTests.swift
//  hasm
//
//  Created by Tiago Lopes on 12/11/24.
//

@testable import Hasm
import Testing

struct BinaryTests {
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
    func testBinaryOfRegularAddressInstructions(
        testArguments: (val: String, bin: String)
    ) throws {
        let aInstruction = Instructions.Address(val: testArguments.val)
        #expect(try aInstruction.binaryRepresentation == testArguments.bin)
    }
    
    @Test(
        arguments: [
            "1112444112241422",
            "    \t."
        ]
    )
    func testBinaryTranslationOfAddressInstructionGeneratesError(val: String) {
        let aInstruction = Instructions.Address(val: val)
        #expect(throws: BinaryTranslationError.self) {
            try aInstruction.binaryRepresentation
        }
    }
}