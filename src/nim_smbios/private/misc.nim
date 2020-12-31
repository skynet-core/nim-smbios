import packed, streams, defines
import defines

const
    paragraph = 16

var    
    buffer: array[paragraph, char]


type
    EPNotFound* = object of CatchableError
    ParseError* = object of CatchableError


proc parseEntryPoint*(stream: Stream, size: int): EntryPoint {. raises: [OSError, IOError] .} =
    case size:
    of 32:
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
    of 64:
        var ep = SMBEntryPoint64()
        let n = stream.readData(addr ep, ep.sizeof)
        if n < ep.sizeof:
            raise newException(IOError, "parse entry point: unexpected EOF")
        result = EntryPoint(
            table: ep.table(),
            version: ep.version(),
        )
    else: discard


proc findEntryPoint*(stream: Stream, startAddr, endAddr: int, size: var int): int {. raises: [IOError, OSError, EPNotFound] .} =
    # looks for entry point instream
    var 
        startAddr = startAddr
        read: int

    stream.setPosition(startAddr)
    while startAddr < endAddr:
        # zeroMem(addr buffer, paragraph)
        read = stream.readData(addr buffer, paragraph)
        if buffer[0..magicPrefix64.high] == magicPrefix64:
            size = 64
            result = startAddr
            return
        elif buffer[0..magicPrefix32.high] == magicPrefix32:
            size = 64
            result = startAddr
            return
        startAddr += paragraph
    raise newException(EPNotFound, "entry point not found")

proc findEntryPointEFI*(stream: Stream, startAddr, endAddr: int, size: var int): int {. raises: [IOError, OSError, EPNotFound] .} =
    # looks for entry point instream
    var 
        startAddr = startAddr
        read: int

    stream.setPosition(startAddr)
    while startAddr < endAddr:
        # zeroMem(addr buffer, paragraph)
        read = stream.readData(addr buffer, paragraph)
        if buffer[0] != '\0':
            try:
                echo buffer
                # echo smb3Guid
                # echo smbGuid
            except: discard
            

        if equalMem(addr buffer[0],smb3Guid.unsafeAddr,16):
            size = 64
            result = startAddr
            return
        elif equalMem(addr buffer[0],smbGuid.unsafeAddr,16):
            size = 32
            result = startAddr
            return

        startAddr += paragraph
    raise newException(EPNotFound, "entry point not found")