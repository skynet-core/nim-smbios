import enums, packed, binary, times, bitops, strformat

type 
    Version*                      = ref object
        maj*: uint8
        min*: uint8
        rev*: uint8
    Header*                       = ref object
        kind:                       DataType
        length:                     uint8
        handle:                     uint16
    Struct*                       = ref object
        handle:                     uint16
        stringSet:                  seq[string]
        case kind: DataType
        of dtBios:
            vendor*:                 string
            version*:                string
            startAddressSegment*:    uint16
            releaseDate*:            DateTime 
            runtimeSize*:            int
            romSize*:                int
            characteristics*:        set[BIOSCharcts]
            release*:                Version
            ecFirmwareRelease*:      Version
        of dtSystem:
            system:                 bool
        else: discard


proc parseReleaseDate(str: string): DateTime =
    if str.len > 8: parse(str, "MM/dd/yyyy")
    else: parse(str, "MM/dd/yy")


proc decodeBiosChars(bits: uint64, bits1, bits2: uint8, version: array[3,int]): set[BIOSCharcts] =
    var 
        i = notSuprt.int
    while i <= necPc98.int:
         if (bits and (1.uint64 shl i.uint64)) != 0:
            # probe each bit
            result.incl(i.BIOSCharcts)
         i += 1
    i = acpi.int
    if version[0]*10 + version[1] >= 24:
        while i <= smartBat.int:
            if (bits1 and (1.uint8 shl (i mod 8).uint8)) != 0:
            # probe each bit
                result.incl(i.BIOSCharcts)
            i += 1
        while i <= vm.int:
            if (bits2 and (1.uint8 shl (i mod 8).uint8)) != 0:
            # probe each bit
                result.incl(i.BIOSCharcts)
            i += 1


proc shiftTo*[T](src: ptr T, offset: uint): ptr T =
    result = cast[ptr T](cast[uint](src) + offset)


proc newBiosStruct(src: SMBBIOSInformation,
     version: array[3, int], stringsSet: seq[string]): Struct {. raises: [TimeParseError].} =
    

    result = Struct(
        kind: dtBios,
        handle: src.header.handle,
        stringSet: newSeq[string](),
        vendor: stringsSet[src.vendor-1],
        version: stringsSet[src.version-1],
        startAddressSegment: src.startAddressSegment,
        # releaseDate: parseReleaseDate(stringsSet[src.releaseDate-1]),
        runtimeSize: (0x10000 - src.startAddressSegment).int * 16,
        romSize: if src.romSize == 0xff: -1 else: (src.romSize.int * 64 * 1024) ,
        characteristics: decodeBiosChars(
                            src.characteristics,
                            src.characteristicsExt1,
                            src.characteristicsExt2,
                            version),
        release: Version(maj:src.majorRelease,min: src.minorRelease,rev:0),
        ecFirmwareRelease: Version(maj:src.ecFirmwareMajorRelease,min:src.ecFirmwareMinorRelease,rev: 0),
        )


proc addStr*(self: var Struct, str: string): void =
    self.stringSet.add(str)


proc fillStrProps*(self: var Struct): void =
    discard

proc decode*(kind: uint8, data: seq[char], stringsSet: seq[string],
    version: array[3,int]): Struct {. raises: [TimeParseError].} =
    # decodes raw binary data chunk into Struct based on kind
    # echo stringsSet
    var 
        data = data
    case kind:
    of dtBios.uint8:
        var smbBios: SMBBIOSInformation
        smbBios.fromBin(data)
        echo smbBios
        result = newBiosStruct(smbBios, version, stringsSet)
    else: discard