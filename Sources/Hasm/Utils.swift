//
//  Utils.swift
//  Hasm
//
//  Created by Tiago Lopes on 14/11/24.
//

extension String {
    var isValidLabel: Bool {
        (first?.isLetter ?? false) && allSatisfy { char in
            return char.isNumber ||
                   char.isLetter ||
                   char == "."   ||
                   char == "$"   ||
                   char == "_"
        }
    }
    
    var isValidAddress: Bool {
        allSatisfy(\.isNumber)
    }
}
