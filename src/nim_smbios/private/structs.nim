import enums, packed, binary, times, guid, strutils

type 
    ChassisElemKind*                    = enum
        cekBoard,
        cekStruct
    Version*                        = ref object
        maj*:                       uint8
        min*:                       uint8
        rev*:                       uint8
    Header*                         = object
        kind:                       DataType
        length:                     uint8
        handle:                     uint16
    Struct*                         = ref object of RootObj
        header*: Header
    BiosInfo*                       = ref object of Struct
        vendor*:                    string
        biosVersion*:               string
        startAddressSegment*:       uint16
        releaseDate*:               DateTime 
        runtimeSize*:               int
        romSize*:                   int
        characteristics*:           set[BIOSCharcts]
        biosRelease*:               Version
        ecFirmwareRelease*:         Version
    SystemInfo*                     = ref object of Struct
        manufacturer*:              string                     
        productName*:               string                    
        serialNumber*:              string                     
        uuid*:                      GUID                               
        sysVersion:                 string
        wakeUpReason:               SysWakeUpType              
        skuNumber:                  string                      
        family:                     string
    BaseBoard*                      = ref object of Struct
        manufacturer*:              string
        product*:                   string
        version*:                   string
        serialNumber*:              string
        assetTagNumber*:            string
        features*:                  set[BoardFeature]
        locationInChassis*:         string
        chassisHandle*:             uint16
        boardType*:                 BoardType
        numberOfContainedHandles*:  uint8
        containedObjectHandles*:    seq[uint16]
    ChassisElement*                 = object
        case kind:ChassisElemKind
        of cekStruct:
            structKind*:            DataType
        of cekBoard:
            boardType*:             BoardType
        elMin*: uint8
        elMax*: uint8

    Chassis*                            = ref object of Struct
        manufacturer*:                  string
        lockPresent*:                   bool
        kind*:                          ChassisType
        version*:                       string
        serialNumber*:                  string
        assetTagNumber*:                string
        bootUpState*:                   ChassisState                      # 2.1 + # enum
        powerSupplyState*:              ChassisState                 #       # enum
        thermalState*:                  ChassisState                     #       # enum
        securityStatus*:                ChassisSecStatus                    #       # enum
        oemDefined*:                    uint32                      # 2.3 + # varies
        heightInch*:                    uint8                           #       # varies
        numberOfPowerCords*:            uint8               #       # varies     #       # varies
        containedElemets*:              seq[ChassisElement]          #       # varies                 
        skuNumber*:                     string                      # 2.7 + # string
    CoolingDevice*                  = ref object of Struct
        tempProbHandle*:            uint16
        devType*:                   CoolingDeviceType
        status*:                    CoolingDeviceStatus
        coolingUintGroup*:          uint8
        oemDefined*:                uint32
        nomiSpeed*:                 int32
        description*:               string


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

proc decodeBoardFeatures(bit: byte): set[BoardFeature] = 
    var i = bfHostBrd.int
    while i <= bfSwapable.int:
        if (bit and (1.uint8 shl i.uint8)) != 0:
            # probe each bit
            result.incl(i.BoardFeature)
        i += 1

proc decodeBoardHandles(raw: ptr UncheckedArray[uint16], num: uint8): seq[uint16] =
    for i in 0..<num.int:
        result.add(raw[i])


proc decodeChassisElements(arr: ptr UncheckedArray[SMBChassisElement], num: uint8, len: uint8): seq[ChassisElement] =
    if num * len > 0:
        var 
            tmp: SMBChassisElement
            ins: ChassisElement
            list = newSeq[ChassisElement](num.int)
        for i in 0..<num.int:
            tmp = arr[i]
            ins = ChassisElement()
            case (tmp.kind shr 7):
            of cekBoard.uint8:
                ins.boardType = (tmp.kind and 0x7f).BoardType
            of cekStruct.uint8:
                ins.structKind = (tmp.kind and 0x7f).DataType
            else: discard
            ins.elMax = tmp.elMax
            ins.elMin = tmp.elMin

proc shiftTo[T](src: ptr T, offset: uint): ptr T =
    result = cast[ptr T](cast[uint](src) + offset)


proc newBiosStruct(src: SMBBIOSInformation,
     version: int, stringsSet: seq[string]): Struct {. raises: [TimeParseError].} =

    result = BiosInfo(
        header: Header(kind: dtBios, length: src.header.length, handle: src.header.handle),
        vendor: stringsSet[src.vendor-1].strip(),
        biosVersion: stringsSet[src.version-1].strip(),
        startAddressSegment: src.startAddressSegment,
        releaseDate: parseReleaseDate(stringsSet[src.releaseDate-1].strip()),
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
    result = CoolingDevice(
        header: Header(kind: dtCoolingDevice, length: src.header.length, handle: src.header.handle),
        tempProbHandle: src.tempProbHandle,
        devType: (src.devTypeAndStatus and (0xff shr 3).uint8).CoolingDeviceType,
        status: (src.devTypeAndStatus and (0x06 shl 5).uint8).CoolingDeviceStatus,
        coolingUintGroup: src.coolingUintGroup,
        oemDefined: src.oemDefined,
        nomiSpeed:  if src.nomiSpeed == 0x8000: -1'i32 else: src.nomiSpeed.int32,
        description: if version >= 270: stringSet[src.description - 1].strip() else: "",
    )

proc newSystemInfo(src: SMBSystemInformation, version: int, stringSet: seq[string]): Struct =
    var si = SystemInfo(
        header: Header(kind: dtSystem, length: src.header.length, handle: src.header.handle),
        manufacturer: stringSet[src.manufacturer - 1].strip(),
        productName: stringSet[src.productName - 1].strip(),
        serialNumber: stringSet[src.serialNumber - 1].strip(),
        sysVersion: stringSet[src.version - 1].strip(),
        uuid: initGuid(data = src.uuid),
        wakeUpReason: swtReserved,
        skuNumber: "",
        family:""
    )
    if version >= 210:
        si.wakeUpReason = src.wakeUpReason.SysWakeUpType
    if version >= 240:
        si.skuNumber = stringSet[src.skuNumber - 1].strip()
        si.family = stringSet[src.family - 1].strip()
    result = si

proc newBoardInfo(src: SMBBaseBoard, version: int, stringSet: seq[string]): Struct =
    result = BaseBoard(
        header: Header(kind: dtSystem, length: src.header.length, handle: src.header.handle),
        manufacturer: stringSet[src.manufacturer - 1].strip(),
        product: stringSet[src.product - 1].strip(),
        version: stringSet[src.version - 1].strip(),
        serialNumber: stringSet[src.serialNumber - 1].strip(),
        assetTagNumber: stringSet[src.assetTagNumber - 1].strip(),
        features: decodeBoardFeatures(src.featureFlags),
        locationInChassis: stringSet[src.locationInChassis - 1].strip(),
        chassisHandle: src.chassisHandle,
        boardType: src.boardType.BoardType,
        numberOfContainedHandles: src.numberOfContainedHandles,
        containedObjectHandles: decodeBoardHandles(
                                    cast[ptr UncheckedArray[uint16]](src.unsafeAddr),
                                    src.numberOfContainedHandles),
    )

proc newChassisInfo(src: SMBChassis, version: int, stringSet: seq[string]): Struct =
    var res = Chassis()
    defer:
        result = res
    if version >= 200:
        res.header = Header(kind: dtSystem, length: src.header.length, handle: src.header.handle)
        res.manufacturer = stringSet[src.manufacturer - 1].strip()
        res.lockPresent = (src.kind shr 7) == 1
        res.kind = (src.kind and 0x7f).ChassisType
        res.version = stringSet[src.version - 1].strip()
        res.serialNumber = stringSet[src.serialNumber - 1].strip()
        res.assetTagNumber = stringSet[src.assetTagNumber - 1].strip()
    if version >= 210:
        res.bootUpState = src.bootUpState.ChassisState
        res.powerSupplyState = src.powerSupplyState.ChassisState
        res.thermalState = src.thermalState.ChassisState
        res.securityStatus = src.securityStatus.ChassisSecStatus
    if version >= 230:
        res.oemDefined  = src.oemDefined
        res.heightInch      = src.height
        res.numberOfPowerCords = src.numberOfPowerCords
        res.containedElemets = decodeChassisElements(src.containedElemets,
             src.containedElementCount, src.containedElementRecordLength)
    if version >= 270:
        if src.skuNumber - 1 != 0xff:
            res.skuNumber = stringSet[src.skuNumber - 1].strip()
        else: res.skuNumber = "BAD INDEX"
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
    of dtBaseBoard.uint8:
        var src: SMBBaseBoard
        src.fromBin(data)
        result = newBoardInfo(src, ver, stringsSet)
    of dtChasis.uint8:
        var src: SMBChassis
        src.fromBin(data)
        result = newChassisInfo(src, ver, stringsSet)
    of dtCoolingDevice.uint8:
        var src: SMBCoolingDevice
        src.fromBin(data)
        result = newCoolingDevice(src, ver, stringsSet)
    else: discard