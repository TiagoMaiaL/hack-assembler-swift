import ArgumentParser

@main
struct Hasm: ParsableCommand {
    @Argument var asmFilePath: String
    @Argument var outputFilePath: String
    
    func run() throws {
        let inputFile = try InputFile(path: asmFilePath)
        let parser = Parser()
        var labelTable = LabelTable()
        var lineNumber = 0

        let instructions = try inputFile.lines()
            .map(parser.parse)

        
        instructions.forEach { instruction in
            switch instruction {
            case _ as Instructions.Address, _ as Instructions.Computation:
                lineNumber += 1
                
            case let symbol as Instructions.Symbol:
                labelTable.associate(symbol: symbol.name, to: lineNumber + 1)
            
            default: break
            }
        }
        
        let binary = try instructions
            .compactMap { $0 as? BinaryRepresentable }
            .map { try $0.binaryRepresentation(using: &labelTable) }
            .reduce("") { partialResult, bin in
                partialResult + (partialResult.isEmpty ? "" : "\n") + bin
            }
        
        let outputFile = try OutputFile(path: outputFilePath)
        try outputFile.write(text: binary)
    }
}
