# Contains defintions of SMBIOS structs

type 
    SMBStructHeader* {. packed .} = object
        kind*: uint8
        length*: uint8
        handle*: uint16
    DMIEntryPoint* {. packed .} = object 
        anchor*: array[5, uint8]
        checksum*: uint8
        tableLength*: uint16
        tableAddress*: uint32
        structureCount*: uint16
        bcdRevision*: uint8
when system.hostOS == "linux":
        type
            SMBEntryPoint32* {. packed .} = object
                anchor*: array[4, uint8]
                checksum: uint8
                length: uint8
                majorVersion: uint8
                minorVersion: uint8
                maxStructSize: uint16
                entryPointRevision: uint8
                formattedArea: array[5, uint8]
                intermediateAnchor: array[5, uint8]
                intermediateChecksum: uint8
                structureTableLength: uint16
                structureTableAddress: uint32
                structuresCount: uint16
                bcdRevision: uint8
            SMBEntryPoint64* {. packed .} = object
                anchor*: array[5, uint8]
                checksum: uint8
                length: uint8
                majorVersion: uint8
                minorVersion: uint8
                docRev: uint8
                entryPointRevision: uint8
                reserved: uint8
                maximumStructureSize: uint32
                structureTableAddress: uint64
elif system.hostOS == "darwin":
        type
            SMBEntryPoint64* {. packed .} = object
                anchor: array[4, uint]
                checksum: uint8
                length: uint8
                majorVersion: uint8
                minorVersion: uint8
                maxStructureSize: array[2, uint8]
                entryPointRevision: uint8
                formattedArea: array[5, uint8]
                dmi: DMIEntryPoint
            SMBEntryPoint32* = SMBEntryPoint64
            # empty stub type

else:
    type 
        SMBEntryPoint = ref object
        # empty stub type
type 
    SMBBIOSInformation* {. packed .} = object
        header*: SMBStructHeader                 # 2.0 + #           #   Type 0
        vendor*: uint8                           #       # string    #   BIOS vendor name, version 2.0 +
        version*: uint8                          #       # string    #   BIOS version
        startAddressSegment*: uint16             #       # varies    #   BIOS segment start
        releaseDate*: uint8                      #       # string    #   BIOS release date
        romSize*: uint8                          #       #       (n); 64K * (n+1) bytes
        characteristics*: uint64                 # 2.4 + #       supported BIOS functions
        characteristicsExt1*: uint8              #       # 
        characteristicsExt2*: uint8              #       #
        majorRelease*: uint8                     #       #
        minorRelease*: uint8                     #       #
        ecFirmwareMajorRelease*: uint8           #       #
        ecFirmwareMinorRelease*: uint8           #       #
        extRomSize*: uint16                      # 3.1 + #

    SMBSystemInformation* {. packed .} = object 
        header: SMBStructHeader                 # 2.0 + #
        manufacturer: uint8                     #       #
        productName: uint8                      #       #
        version: uint8                          #       #
        serialNumber: uint8                     #       #
        uuid: array[16, uint8]                  # 2.1 + # can be all 0 or all 1's, version 2.1+
        wakeUpReason: uint8                     #       # reason for system wakeup
        skuNumber: uint8                        # 2.4 + # 
        family: uint8                           #       #

    SMBBaseBoard* {. packed .} = object
        header: SMBStructHeader                 # 2.0 + #
        manufacturer: uint8                     #       # string
        product: uint8                          #       # string
        version: uint8                          #       # string
        serialNumber: uint8                     #       # string
        assetTagNumber: uint8                   #       # string
        featureFlags: uint8                     #       # Bit Field
        locationInChassis: uint8                #       # string
        chassisHandle: uint16                   #       # varies
        boardType: uint8                        #       # ENUM
        numberOfContainedHandles: uint8         #       # Varies    #   Number (0 to 255) of Contained Object Handles that follow
        # containedObjectHandles: uint16        #       # Varies    #   List of handles of other structures (for example, Baseboard,
                                                                    # Processor, Port, System Slots, Memory Device) that are
                                                                    # contained by this baseboard

    SMBChasis* {. packed .} = object
        header: SMBStructHeader                 # 2.0 + #
        manufacturer: uint8                     #       # string
        kind: uint8                             #       # varies
        version: uint8                          #       # string
        serialNumber: uint8                     #       # string
        assetTagNumber: uint8                   #       # string
        bootUpState: uint8                      # 2.1 + # enum
        powerSupplyState: uint8                 #       # enum
        thermalState: uint8                     #       # enum
        securityStatus: uint                    #       # enum
        oemDefined: uint32                      # 2.3 + # varies
        height: uint8                           #       # varies
        numberOfPowerCords: uint8               #       # varies
        containedElementCount: uint8            #       # varies
        containedElementRecordLength: uint8     #       # varies
        # containedElemets: seq[uint8]          #       # varies                 
        # skuNumber: uint8                      # 2.7 + # string

    SMBProcessorInformation* {. packed .} = object
        header: SMBStructHeader                 #       #
        socket: uint8                           # 2.0 + #
        kind: uint8                             #       #
        family: uint8                           #       #
        manufacturer: uint8                     #       #
        cpuID: uint64                           #       #   # based on CPUID
        version: uint8                          #       #
        voltage: uint8                          #       #   # bit7 cleared indicate legacy mode
        externalClock: uint8                    #       #   # external clock in MHz
        maximumSpeed: uint16                    #       #   # max internal clock in MHz
        currentSpeed: uint16                    #       #   # current internal clock in MHz
        status: uint8                           #       #
        upgrade: uint8                          #       #   # processor upgrade enum
        l1CacheHandle: uint16                   # 2.1 + #
        l2CacheHandle: uint16                   #       #
        l3CacheHandle: uint16                   #       #
        serialNumber: uint8                     # 2.3 + #
        assetTag: uint8                         #       #
        partNumber: uint8                       #       #
        coreCount: uint8                        # 2.5 + #
        coreEnabled: uint8                      #       #
        threadCount: uint8                      #       #
        characteristics: uint16                 #       #
        family2: uint16                         # 2.6 + #        
        coreCount2: uint16                      # 3.0 + #
        coreEnabled2: uint16                    #       #
        threadCount2: uint16                    #       #

    SMBCacheInformation* {. packed .} = object
        header: SMBStructHeader                 #       #
        socketDesignation: uint8                # 2.0 + #
        cacheConfiguration:uint16               #       #   
        maximumCacheSize:uint16                 #       #
        installedSize:uint16                    #       #
        supportedSRAMType:uint16                #       #
        currentSRAMType:uint16                  #       #
        cacheSpeed: uint8                       # 2.1 + #
        errorCorrectionType: uint8              #       #
        systemCacheType: uint8                  #       #
        associativity: uint8                    #       #
        maximumCacheSize2: uint32               # 3.1 + #
        installedSize2: uint32                  #       #

# TODO:     TypeSystemSlots* = 9
# TODO:     TypePhysicalMemoryArray* = 16

    SMBMemoryDevice* {. packed .} = object 
        header: SMBStructHeader
        arrayHandle: uint16                     #       #   # handle of the parent memory array
        errorHandle: uint16                     #       # handle of a previously detected error
        totalWidth: uint16                      #       # total width in bits; including ECC bits
        dataWidth: uint16                       #       # data width in bits
        memorySize: uint16                      #       # bit15 is scale, 0 = MB, 1 = KB
        formFactor: uint8                       #       # memory device form factor
        deviceSet: uint8                        #       # parent set of identical memory devices
        deviceLocator: uint8                    #       # labeled socket; e.g. "SIMM 3"
        bankLocator: uint8                      #       # labeled bank; e.g. "Bank 0" or "A"
        memoryType: uint8                       #       # type of memory
        memoryTypeDetail: uint16                #       # additional detail on memory type
        memorySpeed: uint16                     #       # speed of device in MHz (0 for unknown), version 2.3+ spec (27 bytes)
        manufacturer:uint8                      #       #
        serialNumber:uint8                      #       #
        assetTag:uint8                          #       #
        partNumber: uint8                       #       #
        attributes: uint8                       # 2.6 + #      
        extendedSize: uint32                    # 2.7 + #
        configuredMemorySpeed: uint16           #       #
        minimumVoltage:uint16                   # 2.8 + #
        maximumVoltage:uint16                   #       #
        configuredVoltage:uint16                #       #
        memoryTechnology:uint8                  # 3.2+  #
        operatingModeCap:uint16                 #       #
        firmwareVersion: uint8                  #       #
        moduleManufacturerID:uint16             #       #
        moduleProductID:uint16                  #       #
        moduleSubsysCtrlManufacturerID:uint16   #       #
        moduleSubsysCtrlProductID:uint16        #       #
        nonVolatileSize: uint64                 #       #
        volatileSize: uint64                    #       #
        cacheSize: uint64                       #       #
        logicalSize: uint64                     #       #
    
type 
    SMBEntryPoint* = SMBEntryPoint32 or SMBEntryPoint64
    UnknowPrefix* = object of CatchableError
    EntryPoint* = object
        table*: array[2, int]
        version*: array[3, int]


# procedures

proc table*(ep: SMBEntryPoint32): array[2, int] =
    when hostOS in ["linux"]:
            result = [ep.structureTableAddress.int, ep.structureTableLength.int]
    elif hostOS is "darwin":
            result = [ep.dmi.tableAddress.int, ep.dmi.tableLength.int]
    else:
        raise newException(OSError, "os " & hostOS & " is not supported yet")


proc table*(ep: SMBEntryPoint64): array[2, int] =
    when hostOS in ["linux"]:
            result = [ep.structureTableAddress.int, ep.maximumStructureSize.int]
    elif hostOS is "darwin":
            result = [ep.dmi.tableAddress.int, ep.dmi.tableLength.int]
    else:
        raise newException(OSError, "os " & hostOS & " is not supported yet")


proc version*(ep: SMBEntryPoint): array[3, int] = 
    when hostOS in ["linux"]:
            result = [ep.majorVersion.int ,ep.minorVersion.int, ep.entryPointRevision.int]
    elif hostOS is "darwin":
            result = [ep.majorVersion.int ,ep.minorVersion.int, ep.entryPointRevision.int]
    else:
        raise newException(OSError, "os " & hostOS & " is not supported yet")

