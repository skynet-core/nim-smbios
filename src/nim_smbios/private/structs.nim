import enums, packed, binary, times, guid, strutils, math

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

    Processor*                          = ref object of Struct
        socket*: string                          
        kind*: ProcessorType                            
        family*: ProcessorFamily     
        manufacturer*: string        
        cpuID*: uint64
        when defined(i386) or defined(amd64):
            flags*: set[uint8] # TODO: cpu id for x86, ARM32, ARM64 and Risc-V
        version*: string
        configurable*: bool             
        voltage*: float32            
        externalClockMHz*: uint16     
        maximumSpeedMHz*: uint16        
        currentSpeedMHz*: uint16        
        populated*: bool
        status*: ProcessorStatus 
        upgrade*: ProcessorUpgrade              
        l1CacheHandle*: int       
        l2CacheHandle*: int       
        l3CacheHandle*: int       
        serialNumber*: string        
        assetTag*: string             
        partNumber*: string           
        coreCount*: uint16            
        coreEnabled*: uint16          
        threadCount*: uint16          
        characteristics*: set[ProcessorFeature]       
    CoolingDevice*                  = ref object of Struct
        tempProbHandle*:            uint16
        devType*:                   CoolingDeviceType
        status*:                    CoolingDeviceStatus
        coolingUintGroup*:          uint8
        oemDefined*:                uint32
        nomiSpeed*:                 int32
        description*:               string


proc parseReleaseDate(str: string): DateTime =
    try:
        if str.len > 8: 
            result = parse(str, "MM/dd/yyyy")
        else: 
            result = parse(str, "MM/dd/yy")
    except:
        discard
        

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

proc decodeProcFuncs(word: uint16): set[ProcessorFeature] =
    var i = pfcUnknown.int
    while i <= pfcArm64SoCID.int:
        if (word and (1.uint16 shl i.uint16)) != 0:
            # probe each bit
            result.incl(i.ProcessorFeature)
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
            list[i] = ins
        result = list 

proc shiftTo[T](src: ptr T, offset: uint): ptr T =
    result = cast[ptr T](cast[uint](src) + offset)


proc getString(src: seq[string], ind: uint8): string =
    if ind - 1 != 0xff:
        result = src[ind.int - 1].strip()
    else: 
        result = "BAD INDEX"

proc newBiosStruct(src: SMBBIOSInformation,
     version: int, stringsSet: seq[string]): Struct =

    var res = BiosInfo()
    if version >= 200:
        res.header = Header(kind: dtBios, length: src.header.length, handle: src.header.handle)
        res.vendor = getString(stringsSet, src.vendor)
        res.biosVersion = getString(stringsSet,src.version)
        res.startAddressSegment = src.startAddressSegment
        res.releaseDate = parseReleaseDate(getString(stringsSet,src.releaseDate))
        res.runtimeSize = (0x10000 - src.startAddressSegment).int * 16
        res.romSize = if src.romSize == 0xff: 
                    if version >= 310: (src.extRomSize and (uint16.high shl 2)).int * 
                                        (case 2 shl 13: 
                                            of 0: 2 shl 20 
                                            of 1: 2 shl 30
                                            else: 0).int
                    else: -1
                else: ((src.romSize.int + 1) * 64 * 1024)
        res.characteristics = decodeBiosChars(
                            src.characteristics,
                            src.characteristicsExt1,
                            src.characteristicsExt2,
                            version)
    if version >= 240:
        res.biosRelease = Version(maj:src.majorRelease,min: src.minorRelease,rev:0)
        res.ecFirmwareRelease = Version(maj:src.ecFirmwareMajorRelease,min:src.ecFirmwareMinorRelease,rev: 0)
    if version >= 310:
        if res.romSize < 0:
            let bit = (src.extRomSize and 0xC000)
            if bit == 0:
                res.romSize = (src.extRomSize and 0x3FFF).int
            elif bit == 1:
                res.romSize = (src.extRomSize and 0x3FFF).int shl 10 # Gb to Mb
    result = res

# TODO: more safe
proc newCoolingDevice(src: SMBCoolingDevice, version: int, stringSet: seq[string]): Struct =
    var res = CoolingDevice()
    if version >= 220:
        res.header = Header(kind: dtCoolingDevice, length: src.header.length, handle: src.header.handle)
        res.tempProbHandle = src.tempProbHandle
        res.devType = (src.devTypeAndStatus and (0xff shr 3).uint8).CoolingDeviceType
        res.status = (src.devTypeAndStatus and (0x06 shl 5).uint8).CoolingDeviceStatus
        res.coolingUintGroup = src.coolingUintGroup
        res.oemDefined = src.oemDefined
        res.nomiSpeed =  if src.nomiSpeed == 0x8000: -1'i32 else: src.nomiSpeed.int32
    if version >= 270:
        res.description = getString(stringSet, src.description)
    result = res

proc newSystemInfo(src: SMBSystemInformation, version: int, stringSet: seq[string]): Struct =
    var res = SystemInfo()
    if version >= 200:
        res.header = Header(kind: dtSystem, length: src.header.length, handle: src.header.handle)
        res.manufacturer = getString(stringSet, src.manufacturer)
        res.productName = getString(stringSet, src.productName)
        res.serialNumber =  getString(stringSet, src.serialNumber)
        res.sysVersion = getString(stringSet, src.version)
        res.uuid = initGuid(data = src.uuid)
        res.wakeUpReason =  swtReserved
    if version >= 210:
        res.wakeUpReason = src.wakeUpReason.SysWakeUpType
    if version >= 240:
        res.skuNumber = getString(stringSet,src.skuNumber)
        res.family = getString(stringSet,src.family)
    result = res


proc newBoardInfo(src: SMBBaseBoard, version: int, stringSet: seq[string]): Struct =
    var res = BaseBoard(
        header: Header(kind: dtBaseBoard, length: src.header.length, handle: src.header.handle),
        manufacturer: getString(stringSet, src.manufacturer),
        product: getString(stringSet, src.product),
        version: getString(stringSet, src.version),
        serialNumber: getString(stringSet, src.serialNumber),
        assetTagNumber: getString(stringSet, src.assetTagNumber),
        features: decodeBoardFeatures(src.featureFlags),
        locationInChassis: getString(stringSet,src.locationInChassis),
        chassisHandle: src.chassisHandle,
        boardType: src.boardType.BoardType,
        numberOfContainedHandles: src.numberOfContainedHandles,
        containedObjectHandles: decodeBoardHandles(
                                    cast[ptr UncheckedArray[uint16]](src.unsafeAddr),
                                    src.numberOfContainedHandles),
    )
    result = res

proc newChassisInfo(src: SMBChassis, version: int, stringSet: seq[string]): Struct =
    var res = Chassis()
    defer:
        result = res
    if version >= 200:
        res.header = Header(kind: dtChasis, length: src.header.length, handle: src.header.handle)
        res.manufacturer = getString(stringSet,src.manufacturer)
        res.lockPresent = (src.kind shr 7) == 1
        res.kind = (src.kind and 0x7f).ChassisType
        res.version = getString(stringSet, src.version)
        res.serialNumber = getString(stringSet, src.serialNumber)
        res.assetTagNumber = getString(stringSet, src.assetTagNumber)
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
        res.skuNumber = getString(stringSet, src.skuNumber)


proc newProcessorInfo(src: SMBProcessorInformation, version: int, stringSet: seq[string]): Struct =
    var res = Processor()
    if version >= 200:
        res.header  = Header(kind: dtProcessor, length: src.header.length, handle: src.header.handle) 
        res.socket  = getString(stringSet,src.socket)                          
        res.kind    = src.kind.ProcessorType                            
        res.family  = src.family.ProcessorFamily     
        res.manufacturer = getString(stringSet, src.manufacturer)       
        res.cpuID   = src.cpuID
        # cpuid flags
        res.version = getString(stringSet, src.version)
        res.voltage = if src.voltage shl 7 == 0: 
                            case src.voltage and 0x03:
                            of 0:
                                5.0'f32
                            of 1:
                                3.3'f32
                            of 2:
                                2.9'f32
                            of 3: 0  # configurable
                            else: 
                                res.configurable = true
                                0
                      else: 
                          round(float32(src.voltage - 0x80) / 10'f32, 1)
        res.externalClockMHz = src.externalClock     
        res.maximumSpeedMHz = src.maximumSpeed       
        res.currentSpeedMHz = src.currentSpeed        
        res.populated = (src.status and 0xC0) == 1 # mask 1100_0000
        res.status = (src.status and 0x07).ProcessorStatus # mask 0000_0111
        res.upgrade = src.upgrade.ProcessorUpgrade
    if version >= 210:    
        res.l1CacheHandle = if src.l1CacheHandle == 0xffff: -1 else: src.l1CacheHandle.int     
        res.l2CacheHandle = if src.l2CacheHandle == 0xffff: -1 else: src.l2CacheHandle.int       
        res.l3CacheHandle = if src.l3CacheHandle == 0xffff: -1 else: src.l3CacheHandle.int
    if version >= 230:
        res.serialNumber = getString(stringSet,src.serialNumber)
        res.assetTag = getString(stringSet,src.assetTag)             
        res.partNumber = getString(stringSet, src.partNumber)           
    if version >= 250:
        res.coreCount = src.coreCount
        res.coreEnabled = src.coreEnabled          
        res.threadCount = src.threadCount          
        res.characteristics = decodeProcFuncs(src.characteristics)
    if version >= 260:
        if res.family == pfUseByte2:
            res.family = src.family2.ProcessorFamily
    if version >= 300:
        if res.coreCount == 0xff:
            res.coreCount = src.coreCount2
        if res.coreEnabled == 0xff:
            res.coreEnabled = src.coreEnabled2
        if res.threadCount == 0xff:
            res.threadCount = src.threadCount2
    result = res

proc decode*(kind: uint8, data: seq[char], stringsSet: seq[string],
    version: array[3,int]): Struct =
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
    of dtProcessor.uint8:
        var src: SMBProcessorInformation
        src.fromBin(data)
        result = newProcessorInfo(src, ver, stringsSet)
    of dtCoolingDevice.uint8:
        var src: SMBCoolingDevice
        src.fromBin(data)
        result = newCoolingDevice(src, ver, stringsSet)
    else: discard