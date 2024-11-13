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
            .split(separator: .newlineSequence)
            .map(String.init)
            .map(removingWhitespaces)
            .map(removingComments)
            .filter { !$0.isEmpty }
    }
    
    private func removingWhitespaces(from line: String) -> String {
        line.filter { !($0.isWhitespace && $0.isNewline) }
    }
    
    private func removingComments(from line: String) -> String {
        var line = line
        let commentPattern = Regex {
            Capture {
                OneOrMore {
                    "//"
                }
                ZeroOrMore(.anyNonNewline)
            }
        }
        
        if let match = line.firstMatch(of: commentPattern) {
            line.removeSubrange(match.range)
        }
        
        return line
    }
}

extension InputFile {
    enum Error: Swift.Error {
        case notFound
        case notAscii
    }
}

struct OutputFile {
    let url: URL
    
    init(path: String) throws {
        let fileManager = FileManager.default
        
        guard let pathURL = URL(
            string: "file://\(fileManager.currentDirectoryPath)/\(path)"
        ) else {
            throw Error.invalidPath
        }
        
        self.url = pathURL
        
        guard fileManager.createFile(
            atPath: path,
            contents: nil
        ) else {
            throw Error.creationFailed
        }
    }
    
    func write(text: String) throws {
        try text.write(
            to: url,
            atomically: false,
            encoding: .ascii
        )
    }
}

extension OutputFile {
    enum Error: Swift.Error {
        case invalidPath
        case creationFailed
    }
}
