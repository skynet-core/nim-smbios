import smbenum

smbEnum DataType:
    dtBios                                  $= "Type 0: BIOS Information"                      #
    dtSystem                                $= "Type 1: System Information"
    dtBaseBoard                             $= "Type 2: Base Board Information"
    dtChasis                                $= "Type 3: System Enclosure or Chassis"
    dtProcessor
    dtMemoryController # obsolete
    dtMemoryModule # obsolete
    dtCache
    dtPortConnector
    dtSystemSlots
    dtOnBoardDevices # obsolete
    dtOemStrings
    dtSysConfigOptions
    dtBiosLang
    dtGrpAssosiations 
    dtSysEventLog 
    dtPhysicalMemoryArray 
    dtMemory 
    dtMemError32 
    dtMemoryArrayMappedAddress 
    dtMemoryDeviceMappedAddress 
    dtBuiltInPointingDevice 
    dtPortableBattery 
    dtSystemReset 
    dtHarwareSecurity 
    dtSystemPowerControls 
    dtVoltageProbe 
    dtCoolingDevice $= "Type 27: Cooling Device"
    dtTemperatureProbe 
    dtElectricalCurrentProbe 
    dtOutOfBandRemoteAccess 
    dtBisEntryPoint 
    dtSystemBootInfo 
    dtMemError64 
    dtManagmentDevice 
    dtManagmentDeviceComponent 
    dtManagmentDeviceThresholdData 
    dtMemoryChannel 
    dtIpmiDevice 
    dtSystemPowerSupply 
    dtAdditional 
    dtOnBoardDevicesExtended 
    dtManagmentControllerHostInterface 
    dtTpmDevice 
    dtProcessorAdditional # TODO: add high proc by ! mark
    dtInactive = 126
    dtEndOfTable = 127


smbEnum BIOSCharcts:
    # maps bit numbers to their meaning
    reserved0            = 0     $= "Reserved"
    reserved1            = 1     $= "Reserved"
    unknown              = 2     $= "Unknown"
    notSuprt             = 3     $= "BIOS Characteristics are not supported."
    isaSuprt             = 4     $= "ISA is supported."
    mcaSuprt             = 5     $= "MCA is supported."
    eisa                 = 6     $= "EISA is supported."
    pci                  = 7     $= "PCI is supported."
    pcmCIA               = 8     $= "PC card (PCMCIA) is supported."
    pNp                  = 9     $= "Plug and Play is supported."
    apm                  = 10    $= "APM is supported."
    isFlash              = 11    $= "BIOS is upgradeable (Flash)."
    shadowing            = 12    $= "BIOS shadowing is allowed."
    vlVesa               = 13    $= "VL-VESA is supported."
    escd                 = 14    $= "ESCD support is available."
    cdBoot               = 15    $= "Boot from CD is supported."
    select1              = 16    $= "Selectable boot is supported."
    romSocketed          = 17    $= "BIOS ROM is socketed."
    pcCardBoot           = 18    $= "Boot from PC card (PCMCIA) is supported."
    edd                  = 19    $= "EDD specification is supported."
    jpFloppyNec          = 20    $= "Int 13h — Japanese floppy for NEC 9800 1.2 MB (3.5” 1K bytes/sector 360 RPM) is supported."
    jpFloppyToshiba      = 21    $= "Int 13h — Japanese floppy for Toshiba 1.2 MB (3.5” 360 RPM) is supported."
    floppy5_25_360kbSrv  = 22    $= "Int 13h — 5.25” / 360 KB floppy services are supported."
    floppy5_25_1_2Mb     = 23    $= "Int 13h — 5.25” /1.2 MB floppy services are supported."
    floppy3_5_720kb      = 24    $= "Int 13h — 3.5” / 720 KB floppy services are supported."
    floppy3_5_2_88Mb     = 25    $= "Int 13h — 3.5” / 2.88 MB floppy services are supported."
    printScreen5h        = 26    $= "Int 5h print screen Service is supported."
    kbSrv8042            = 27    $= "Int 9h 8042 keyboard services are supported."
    serialSrv            = 28    $= "Int 14h serial services are supported."
    printSrv             = 29    $= "Int 17h printer services are supported."
    cgaMonoVideoSrv      = 30    $= "Int 10h CGA/Mono Video Services are supported."
    necPc98              = 31    $= "NEC PC-98."
# smbEnum BIOSCharctsExt:
    # maps bit numbers to their meaning
    acpi                 = 64     $= "ACPI is supported."
    legacyUsb            = 65     $= "USB Legacy is supported."
    agp                  = 66     $= "AGP is supported."
    i2o                  = 67     $= "I2O boot is supported."
    ls120sd              = 68     $= "LS-120 SuperDisk boot is supported."
    atApiZipDrvBoot      = 69     $= "ATAPI ZIP drive boot is supported."
    boot1394             = 70     $= "1394 boot is supported."
    smartBat             = 71     $= "Smart battery is supported."
# smbEnum BIOSCharctsExtB2:
    # maps bit numbers to their meaning
    bootSpec            = 72      $= "BIOS Boot Specification is supported."
    netSrvBoot          = 73      $= "Function key-initiated network service boot is supported."
    trgtContDist        = 74      $= "Enable targeted content distribution."
    uefiSpec            = 75      $= "UEFI Specification is supported."
    vm                  = 76      $= "SMBIOS table describes a virtual machine."
     #                     77
     #                     78
     #                     79
smbEnum CoolingDeviceStatus:
    cdsReserved                   $= "Reserved"
    cdsOther                      $= "Other"
    cdsUnknown                    $= "Unknown"
    cdsOK                         $= "OK"
    cdsNonCrit                    $= "Non-Critical"
    cdsCrit                       $= "Critical"
    cdsNonRecov                   $= "Non-Recoverable"

smbEnum CoolingDeviceType:
    cdtReserved                   $= "Reserved"
    cdtUnkn                       $= "Unknown"
    cdtFan                        $= "Fan"
    cdtCentBlower                 $= "Centrifugal Blower"
    cdtChipFan                    $= "Chip Fan"
    cdtCabinetFan                 $= "Cabinet Fan"
    cdtPowSuplFan                 $= "Power Supply Fan"
    cdtHeatPipe                   $= "Heat Pipe"
    cdtIntegrRefrig               $= "Integrated Refrigeration"
    cdtActCool                    $= "Active Cooling"
    cdtPasCool                    $= "Passive Cooling"

smbEnum SysWakeUpType:
    swtReserved                   $= "Reserved"
    swtOther                      $= "Other"
    swtUnknown                    $= "Unknown"
    swtApmTm                      $= "APM Timer"
    swtModemRn                    $= "Modem Ring"
    swtLanRem                     $= "LAN Remote"
    swtPowSwich                   $= "Power Switch"
    swtPciPme                     $= "PCI PME#"
    swtACPowRes                   $= "AC Power Restored"

smbEnum BoardFeature:
    bfHostBrd                     $= "Hosting Board"
    bfReqAuxBrd                   $= "Requires Daughter Board"
    bfRemovable                   $= "Board is Removable"
    bfReplaceble                  $= "Board is Replaceable"
    bfSwapable                    $= "Board is Hot-Swappable"

smbEnum BoardType:
    btUnknown                     $= "Unknown"
    btOther                       $= "Other"
    btSrvBlade                    $= "Server Blade"
    btConSwitch                   $= "Connectivity Switch"
    btSmm                         $= "System Management Module"
    btCpuMod                      $= "Processor Module"
    btIoMod                       $= "I/O Module"
    btMemMod                      $= "Memory Module"
    btDaughter                    $= "Daughter board"
    btMother                      $= "Motherboard (includes processor, memory, and I/O)"
    btCpuMemMod                   $= "Processor/Memory Module"
    btCpuIoMod                    $= "Processor/IO Module"
    btInterconMod                 $= "Interconnect board"

smbEnum ChassisType:
   ctEmpty                        $= "Unset"
   ctOther                        $= "Other"
   ctUnknown                      $= "Unknown"
   ctDesktop                      $= "Desktop"
   ctLowProfDesk                  $= "Low Profile Desktop"
   ctPizzaBox                     $= "Pizza Box"
   ctMinTower                     $= "Mini Tower"
   ctTower                        $= "Tower"
   ctPortable                     $= "Portable"
   ctLaptop                       $= "Laptop"
   ctNotebook                     $= "Notebook"
   ctHandHeld                     $= "Hand Held"
   ctDockingStation               $= "Docking Station"
   ctAllInOne                     $= "All in One"
   ctSubNotebook                  $= "Sub Notebook"
   ctSpaceSaving                  $= "Space-saving"
   ctLunchBox                     $= "Lunch Box"
   ctMainServerChassis            $= "Main Server Chassis"
   ctExpansionChassis             $= "Expansion Chassis"
   ctSubChassis                   $= "SubChassis"
   ctBusExpChassis                $= "Bus Expansion Chassis"
   ctPeripheralChassis            $= "Peripheral Chassis"
   ctRaidChassis                  $= "RAID Chassis"
   ctRackMountCh                  $= "Rack Mount Chassis"
   ctSealedCasePc                 $= "Sealed-case PC"
   ctMultiSysChassis              $= "19h Multi-system chassis"
   ctCompactPCI                   $= "1Ah Compact PCI"
   ctAdvancedTca                  $= "1Bh Advanced TCA"
   ctBlade                        $= "Blade"
   ctBladeEnclosure               $= "Blade Enclosure"
   ctTablet                       $= "Tablet"
   ctConvertible                  $= "Convertible"
   ctDetachable                   $= "Detachable"
   ctIotGateway                   $= "IoT Gateway"
   ctEmbedded                     $= "Embedded PC"
   ctMiniPc                       $= "Mini PC"
   ctStickPC                      $= "Stick PC"

smbEnum ChassisState:
    csEmpty                       $= "Unset"
    csOther                       $= "Other"
    csUnknown                     $= "Unknown"
    csSafe                        $= "Safe"
    csWarning                     $= "Warning"
    csCritical                    $= "Critical"
    csNonRecover                  $= "Non-recoverable"

smbEnum ChassisSecStatus:
    cssEmpty                      $= "Unset"
    cssOther                      $= "Other"
    cssUnknown                    $= "Unknown"
    cssNone                       $= "None"
    cssExtIfLockedOut             $= "External interface locked out"
    cssExtIfEnabled               $= "External interface enabled"

