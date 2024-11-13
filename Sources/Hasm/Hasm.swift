
// TODO: Add the translator module

import ArgumentParser

@main
struct Hasm: ParsableCommand {
    @Argument var asmFilePath: String
    @Argument var outputFilePath: String
    
    func run() throws {
        let inputFile = try InputFile(path: asmFilePath)
        let parser = Parser()
        
        // TODO: parse and collect symbols

        let binary = try inputFile
            .lines()
            .map(parser.parse)
            .compactMap { $0 as? BinaryRepresentable }
            .map { try $0.binaryRepresentation }
            .reduce("") { partialResult, bin in
                return partialResult + "\n" + bin
            }
        
        print(binary)
        // TODO: Output to a file
    }
}
