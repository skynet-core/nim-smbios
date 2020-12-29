# This is just an example to get you started. Users of your library will
# import this file by writing ``import nim_smbios/submodule``. Feel free to rename or
# remove this file altogether. You may create additional modules alongside
# this file as required.
import streams, sequtils, os, tables, os, times, defines, binary, enums
import packed ,misc, defines, structs

type
  Parser* = ref object
    ep: EntryPoint
    data: seq[char]
    structs: TableRef[uint8, seq[Struct]]

proc memoryStreamParser*(stream: Stream, startAddr, endAddr: int): 
    Parser {. raises: [IOError, OSError, EPNotFound ] .} =
    # TODO: UEFI or smb 2?
    var size: int
    let epAddr = findEntryPoint(stream, startAddr, endAddr, size)
    stream.setPosition(epAddr)
    
    let ep = parseEntryPoint(stream, size) 
    result = Parser(ep: ep,
      data: newSeq[char](ep.table[1]))

    stream.setPosition(ep.table[0])
    let n = stream.readData(
      addr result.data,
      ep.table[1])
    if n < ep.table[1]:
        raise newException(IOError, "mem stream parser: unexpected EOF")


proc devMemParser*(path: string, startAddr, endAddr: int): 
  Parser {. raises: [IOError, OSError, EPNotFound, Exception] .} =
    
    var stream = openFileStream(path, fmRead)
    defer: stream.close()
    result = memoryStreamParser(stream, startAddr, endAddr)

proc parserFromAddress*():
  Parser {. raises: [IOError, OSError, Exception] .} =
  
  result = devMemParser(linuxDevMem,linuxSMBIOSRawAddress,linuxSMBIOSRawEndAddres)


proc newParser*(epFile,tableFile: string): Parser {. raises: [UnknowPrefix, OSError, Exception, IOError] .}  =
  let stream = openFileStream(epFile, fmRead)
  defer: stream.close()
  # detect EP size
  var size: int
  let magic = stream.readStr(4)
  case magic:
  of magicPrefix64[0..3]:
    size = 64
  of magicPrefix32:
    size = 32
  else: raise newException(UnknowPrefix, "can't get entrypoint size from prefix: " & magic)

  stream.setPosition(0)
  let ep = parseEntryPoint(stream, size)
  result = Parser(
    ep: ep,
    data: readFile(tableFile).toSeq)


proc parseFromSysFS*():
  Parser {. raises: [IOError, UnknowPrefix, Exception] .} = 
  echo "FS STREAM"
  result = newParser(linuxDMISysfsEntryPoint, linuxDMISysfsPath)

proc discover*(): Parser  =
  when hostOS == "linux":
    if fileExists(linuxDMISysfsPath):
      result = parseFromSysFS()
    else:
      result = parserFromAddress()
  else:
    raise newException(OSError, "os " & hostOS & " is not supported yet")


proc entryPoint*(self: Parser): EntryPoint =
    result = self.ep

proc tableData*(self: Parser): seq[char] =
    result = self.data


proc structs*(self:Parser, kind: uint8): seq[Struct] =
  result = self.structs[kind]


proc parseTable*(p: var Parser): Parser {. raises: [TimeParseError, KeyError].} = 
    # pure function return chnaged object but doesn't change receiver
    var
      self = p
      i,prevI = 0
      startIndex: int
      endIndex: int
      header: SMBStructHeader
      list: seq[Struct]
    
    let 
      version       = self.ep.version
      headerSize    = SMBStructHeader.sizeof
       
    result = self
    self.structs = newTable[uint8,seq[Struct]]()
    while i < self.data.len:
      header.fromBin(self.data[i..<(i+headerSize)])
      if header.kind == dtEndOfTable.uint8:
        break

      list = if self.structs.contains(header.kind): 
                  self.structs[header.kind]
                else:
                  newSeq[Struct]()

      startIndex = i
      endIndex = startIndex + header.length.int
      # skip formatted area      
      i = endIndex
      prevI = i
      var stringsSet = newSeq[string]() 
      # decode formatted structure
      while i < self.data.len:
        # parse string formatted area
        if self.data[i] == '\0':
          # end of string
          stringsSet.add(cast[string](self.data[prevI..<i]))
          prevI = i + 1
          if self.data[i + 1] == '\0':
            # end of string set
            # set index to next struct
            i += 2
            break
        i += 1

      list.add(decode(
          header.kind,
          self.data[startIndex..<endIndex],
          stringsSet, # /null/null
          version))
        
      self.structs[header.kind] = list