import enums, packed, binary, times, bitops, strformat, guid

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
        case kind: DataType
        of dtBios:
            vendor*:                 string
            biosVersion*:                string
            startAddressSegment*:    uint16
            releaseDate*:            DateTime 
            runtimeSize*:            int
            romSize*:                int
            characteristics*:        set[BIOSCharcts]
            biosRelease*:            Version
            ecFirmwareRelease*:      Version
        of dtSystem:
            manufacturer*:           string                     
            productName*:            string                    
            serialNumber*:           string                     
            uuid*:                   GUID                               
            sysVersion:              string
            wakeUpReason:            SysWakeUpType              
            skuNumber:               string                      
            family:                  string                         
        of dtCoolingDevice:
            tempProbHandle*:          uint16
            devType*:                 CoolingDeviceType
            status*:                  CoolingDeviceStatus
            coolingUintGroup*:        uint8
            oemDefined*:              uint32
            nomiSpeed*:               int32
            description*:             string
        else: discard


proc parseReleaseDate(str: string): DateTime =
    if str.len > 8: parse(str, "MM/dd/yyyy")
    else: parse(str, "MM/dd/yy")


proc decodeBiosChars(bits: uint64, bits1, bits2: uint8, version: int): set[BIOSCharcts] =
    var 
        i = notSuprt.int
    while i <= necPc98.int:
         if (bits and (1.uint64 shl i.uint64)) != 0:
            # probe each bit
            result.incl(i.BIOSCharcts)
         i += 1
    i = acpi.int
    if version >= 240:
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


proc shiftTo[T](src: ptr T, offset: uint): ptr T =
    result = cast[ptr T](cast[uint](src) + offset)


proc newBiosStruct(src: SMBBIOSInformation,
     version: int, stringsSet: seq[string]): Struct {. raises: [TimeParseError].} =

    result = Struct(
        kind: dtBios,
        handle: src.header.handle,
        vendor: stringsSet[src.vendor-1],
        biosVersion: stringsSet[src.version-1],
        startAddressSegment: src.startAddressSegment,
        releaseDate: parseReleaseDate(stringsSet[src.releaseDate-1]),
        runtimeSize: (0x10000 - src.startAddressSegment).int * 16,
        romSize: if src.romSize == 0xff: 
                    if version >= 310: (src.extRomSize and (uint16.high shl 2)).int * 
                                        (case 2 shl 13: 
                                            of 0: 2 shl 20 
                                            of 1: 2 shl 30
                                            else: 0).int
                    else: src.romSize.int
                else: ((src.romSize.int + 1) * 64 * 1024) ,
        characteristics: decodeBiosChars(
                            src.characteristics,
                            src.characteristicsExt1,
                            src.characteristicsExt2,
                            version),
        biosRelease: Version(maj:src.majorRelease,min: src.minorRelease,rev:0),
        ecFirmwareRelease: Version(maj:src.ecFirmwareMajorRelease,min:src.ecFirmwareMinorRelease,rev: 0),
        )

proc newCoolingDevice(src: SMBCoolingDevice, version: int, stringSet: seq[string]): Struct =
    result = Struct(
        kind: dtCoolingDevice,
        tempProbHandle: src.tempProbHandle,
        devType: (src.devTypeAndStatus and (0xff shr 3).uint8).CoolingDeviceType,
        status: (src.devTypeAndStatus and (0x06 shl 5).uint8).CoolingDeviceStatus,
        coolingUintGroup: src.coolingUintGroup,
        oemDefined: src.oemDefined,
        nomiSpeed:  if src.nomiSpeed == 0x8000: -1'i32 else: src.nomiSpeed.int32,
        description: if version >= 270: stringSet[src.description - 1] else: "",
    )

proc newSystemInfo*(src: SMBSystemInformation, version: int, stringSet: seq[string]): Struct =
    echo stringSet
    result = Struct(
        kind: dtSystem,
        manufacturer: stringSet[src.manufacturer - 1],
        productName: stringSet[src.productName - 1],
        serialNumber: stringSet[src.serialNumber - 1],
        sysVersion: stringSet[src.version - 1],
        uuid: initGuid(data = src.uuid),
        wakeUpReason: swtReserved,
        skuNumber: "",
        family:""
    )
    if version >= 210:
        result.wakeUpReason = src.wakeUpReason.SysWakeUpType
    if version >= 240:
        result.skuNumber = stringSet[src.skuNumber - 1]
        result.family = stringSet[src.family - 1]


proc decode*(kind: uint8, data: seq[char], stringsSet: seq[string],
    version: array[3,int]): Struct {. raises: [TimeParseError].} =
    # decodes raw binary data chunk into Struct based on kind
    # echo stringsSet
    let ver = version[0] * 100 + version[1]*10 + version[0]
    var 
        data = data
    case kind:
    of dtBios.uint8:
        var src: SMBBIOSInformation
        src.fromBin(data)
        result = newBiosStruct(src, ver, stringsSet)
    of dtSystem.uint8:
        var src: SMBSystemInformation
        src.fromBin(data)
        result = newSystemInfo(src, ver, stringsSet)
    of dtCoolingDevice.uint8:
        var src: SMBCoolingDevice
        src.fromBin(data)
        result = newCoolingDevice(src, ver, stringsSet)
    else: discard