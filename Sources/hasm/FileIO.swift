//
//  FileIO.swift
//  hasm
//
//  Created by Tiago Lopes on 09/11/24.
//

import Foundation
import RegexBuilder

struct InputFile {
    private let contents: Data
    
    init(path: String) throws {
        let contents = FileManager.default.contents(atPath: path)
        
        guard let contents else {
            throw Error.notFound
        }
        
        self.contents = contents
    }
    
    func lines() throws -> [String] {
        let sourceCode = String(
            data: contents,
            encoding: .ascii
        )
        
        guard let sourceCode else {
            throw Error.notAscii
        }
        
        return sourceCode
            .split(separator: "\n")
            .map(String.init)
            .map { string in
                string
                    .filter { (ch: Character) in
                        !(ch.isWhitespace && ch.isNewline)
                    }
            }
            .map { string in
                var string = string
                let commentPattern = Regex {
                    Capture {
                        OneOrMore {
                            "//"
                        }
                        ZeroOrMore(.anyNonNewline)
                    }
                }
                
                if let match = string.firstMatch(of: commentPattern) {
                    string.removeSubrange(match.range)
                }
                
                return string
            }
            .filter { !$0.isEmpty }
    }
}

extension InputFile {
    enum Error: Swift.Error {
        case notFound
        case notAscii
    }
}
