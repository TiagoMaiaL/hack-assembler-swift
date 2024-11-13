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
                partialResult + (partialResult.isEmpty ? "" : "\n") + bin
            }
        
        let outputFile = try OutputFile(path: outputFilePath)
        try outputFile.write(text: binary)
    }
}
