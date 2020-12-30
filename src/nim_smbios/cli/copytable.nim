import os, streams, strutils, binary
import ../private/parser

when isMainModule:
    let args = commandLineParams()
    if args.len < 1:
        quit("specify your pc model to save data",1)

    let name = args[0].replace(' ','_')
    var tableParser = initParser()
    writeFile(name & ".table", cast[string](tableParser.tableData()))
    let epStream = openFileStream(name & ".entry",fmWrite)

    try:
        var ep = tableParser.entryPoint()
        ep.hton()
        epStream.writeData(addr ep, ep.sizeof)
        discard tableParser.parseTable()
    finally:
        epStream.close()