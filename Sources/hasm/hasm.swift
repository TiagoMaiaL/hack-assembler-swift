
// TODO: Add the lexing module
// TODO: Add the parsing module
// TODO: Add the translator module

import ArgumentParser

@main
struct Hasm: ParsableCommand {
    @Argument var asmFilePath: String
    @Argument var outputFilePath: String
    
    func run() throws {
        let inputFile = try InputFile(path: asmFilePath)
        let asmLines = try inputFile.lines()
        print(asmLines)
        
        // TODO: parse and collect symbols
        // TODO: parse and translate instructions
    }
}
