
// TODO: Add the lexing module
// TODO: Add the parsing module
// TODO: Add the translator module
// TODO: Add the file module in charge of handling io

import ArgumentParser

@main
struct Hasm: ParsableCommand {
    @Argument var asmFilePath: String
    @Argument var outputFilePath: String
    
    func run() throws {
        guard let inputFile = InputFile(path: asmFilePath) else {
            return
        }
        
        print("input file successfully loaded.")
        print("input lines: \(try! inputFile.lines())")
    }
}
