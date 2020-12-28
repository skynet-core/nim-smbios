import packed, streams
import defines

const
    paragraph = 16

var    
    buffer: array[paragraph, char]


type
    EPNotFound* = object of CatchableError
    ParseError* = object of CatchableError


proc parseEntryPoint*(stream: Stream): EntryPoint {. raises: [OSError, IOError, UnknowPrefix, ParseError] .} =
    let begin = stream.readStr(4)
    if begin.len < 4:
        raise newException(ParseError,"to few data for prefix")
    stream.setPosition(0)
    case begin:
    of magicPrefix32:
        var ep = SMBEntryPoint32()
        let n = stream.readData(addr ep, ep.sizeof)
        if n < ep.sizeof:
            raise newException(IOError, "parse entry point: unexpected EOF")
        if n < ep.sizeof:
            raise newException(IOError, "parse entry point: unexpected EOF")

        result = EntryPoint(
            table: ep.table(),
            version: ep.version(),
        )


    of magicPrefix64[0..<magicPrefix32.len]:
        var ep = SMBEntryPoint64()
        let n = stream.readData(addr ep, ep.sizeof)
        if n < ep.sizeof:
            raise newException(IOError, "parse entry point: unexpected EOF")
        result = EntryPoint(
            table: ep.table(),
            version: ep.version(),
        )
    else: raise newException(UnknowPrefix,"can't determine entry point type by prefix " & begin)


proc findEntryPoint*(stream: Stream, startAddr, endAddr: int): int {. raises: [IOError, OSError, EPNotFound] .} =
    # looks for entry point instream
    var 
        startAddr = startAddr
        read: int

    stream.setPosition(startAddr)
    while startAddr < endAddr:
        zeroMem(addr buffer, paragraph)
        read = stream.readData(addr buffer, paragraph)
        if buffer[0..2] == magicPrefix:
            result = startAddr
            return
        startAddr += paragraph
    raise newException(EPNotFound, "entry point not found")
