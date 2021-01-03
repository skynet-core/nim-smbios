import smbenum

smbEnum DataType:
    dtBios                                  $= "Type 0: BIOS Information"                      #
    dtSystem                                $= "Type 1: System Information"
    dtBaseBoard                             $= "Type 2: Base Board Information"
    dtChasis                                $= "Type 3: System Enclosure or Chassis"
    dtProcessor                             $= "Type 4: Processor Information"
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
    dtCoolingDevice                         $= "Type 27: Cooling Device"
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

smbEnum ProcessorType:
    ptEmpty                       $= "Empty"
    ptOther                       $= "Other"
    ptUnknown                     $= "Unknown"
    ptCProc                       $= "Central Processor"
    ptMathProc                    $= "Math Processor"
    ptDspProc                     $= "DSP Processor"
    ptVideoProc                   $= "Video Processor"

smbEnum ProcessorFamily:
    pfEmpty                     = 0   $= "Empty"
    pfOther                     = 1   $= "Other"
    pfUnknown                   = 2   $= "Unknown"
    pf8086                      = 3   $= "8086"
    pf80286                     = 4   $= "80286"
    pfI386                      = 5   $= "Intel386TM processor"
    pfI486                      = 6   $= "Intel486TM processor"
    pf8087                      = 7   $= "8087"
    pf80287                     = 8   $= "80287"
    pf80387                     = 9   $= "80387"
    pf80487                     = 10  $= "80487"
    pfIntelPentium              = 11  $= "Intel® Pentium® processor"
    pfPentiumPro                = 12  $= "Pentium® Pro processor"
    pfPentiumII                 = 13  $= "Pentium® II processor"
    pfPentiumMMXTM              = 14  $= "Pentium® processor with MMXTM technology"
    pfIntelCeleron              = 15  $= "Intel® Celeron® processor"
    pfPentiumIIXeonTM           = 16  $= "Pentium® II XeonTM processor"
    pfPentiumIII                = 17  $= "Pentium® III processor"
    pfM1                        = 18  $= "M1 Family"
    pfM2                        = 19  $= "M2 Family"
    pfIntelCeleronM             = 20  $= "Intel® Celeron® M processor"
    pfIntelPentium4HT           = 21  $= "Intel® Pentium® 4 HT processor"
    # 22 Available for assignment
    # 23 Available for assignment
    pfAmdDuron                  = 24  $= "AMD DuronTM Processor Family" # *1
    pfK5                        = 25  $= "K5 Family" # *1
    pfK6                        = 26 $= "K6 Family" # *1
    pfK6_2                      = 27 $= "K6-2" # *1
    pfK6_3                      = 28 $= "K6-3" # *1
    pfAmdAthlonTM               = 29 $= "AMD AthlonTM Processor Family" # *1
    pfAmd2900                   = 30 $= "AMD29000 Family"
    pfK6_2Plus                  = 31 $= "K6-2+"
    pfPowerPC                   = 32 $= "Power PC Family"
    pfPowerPC601                = 33 $= "Power PC 601"
    pfPowerPC603                = 34 $= "Power PC 603"
    pfPowerPC603Plus            = 35 $= "Power PC 603+"
    pfPowerPC604                = 36 $= "Power PC 604"
    pfPowerPC620                = 37 $= "Power PC 620"
    pfPowerPCx704               = 38 $= "Power PC x704"
    pfPowerPC750                = 39 $= "Power PC 750"
    pfIntelCoreDuo              = 40 $= "Intel® CoreTM Duo processor"
    pfIntelCoreDuoMob           = 41 $= "Intel® CoreTM Duo mobile processor"
    pfIntelCoreSoloMob          = 42 $= "Intel® CoreTM Solo mobile processor"
    pfIntelAtom                 = 43 $= "Intel® AtomTM processor"
    pfIntelCoreM                = 44 $= "Intel® CoreTM M processor"
    pfIntelCoreM3               = 45 $= "Intel(R) Core(TM) m3 processor"
    pfIntelCoreM5               = 46 $= "Intel(R) Core(TM) m5 processor"
    pfIntelCoreM7               = 47 $= "Intel(R) Core(TM) m7 processor"
    pfAlphaFamily               = 48 $= "Alpha Family" # *2
    pfAlpha21064                = 49 $= "Alpha 21064"
    pfAlpha21066                = 50 $= "Alpha 21066"
    pfAlpha21164                = 51 $= "Alpha 21164"
    pfAlpha21164PC              = 52 $= "Alpha 21164PC"
    pfAlpha21164a               = 53 $= "Alpha 21164a"
    pfAlpha21264                = 54 $= "Alpha 21264"
    pfAlpha21364                = 55 $= "Alpha 21364"
    pfAmdTurionIIUltDualMob     = 56 $= "AMD TurionTM II Ultra Dual-Core Mobile M Processor Family"
    pfAmdTurionIIDualMob        = 57 $= "AMD TurionTM II Dual-Core Mobile M Processor Family"
    pfAmdAthlonIIDualCoreM      = 58 $= "AMD AthlonTM II Dual-Core M Processor Family"
    pfAmdOpteronTM6100Ser       = 59 $= "AMD OpteronTM 6100 Series Processor"
    pfAmdOpteronTM4100Ser       = 60 $= "AMD OpteronTM 4100 Series Processor"
    pfAmdOpteronTM6200Ser       = 61 $= "AMD OpteronTM 6200 Series Processor"
    pfAmdOpteronTM4200Ser       = 62 $= "AMD OpteronTM 4200 Series Processor"
    pfAmdFXTM                   = 63 $= "AMD FXTM Series Processor"
    pfMips                      = 64 $= "MIPS Family"
    pfMipsR4000                 = 65 $= "MIPS R4000"
    pfMipsR4200                 = 66 $= "MIPS R4200"
    pfMips4400                  = 67 $= "MIPS R4400"
    pfMipsR4600                 = 68 $= "MIPS R4600"
    pfMipsR10000                = 69 $= "MIPS R10000"
    pfAmdC                      = 70 $= "AMD C-Series Processor"
    pfAmdE                      = 71 $= "AMD E-Series Processor"
    pfAmdA                      = 72 $= "AMD A-Series Processor"
    pfAmdG                      = 73 $= "AMD G-Series Processor"
    pfAmdZ                      = 74 $= "AMD Z-Series Processor"
    pfAmdR                      = 75 $= "AMD R-Series Processor"
    pfAmdOpteronTM4300          = 76 $= "AMD OpteronTM 4300 Series Processor"
    pfAmdOpteronTM6300          = 77 $= "AMD OpteronTM 6300 Series Processor"
    pfAmdOpteronTM3300          = 78 $= "AMD OpteronTM 3300 Series Processor"
    pfAmdFireProTM              = 79 $= "AMD FireProTM Series Processor"
    pfSPARC                     = 80 $= "SPARC Family"
    pfSuperSPARC                = 81 $= "SuperSPARC"
    pfMicroSparcII              = 82 $= "microSPARC II"
    pfMicroSparcIIem            = 83 $= "microSPARC IIep"
    pfUltraSPARC                = 84 $= "UltraSPARC"
    pfUltraSPARCII              = 85 $= "UltraSPARC II"
    pfUltraSPARCIll             = 86 $= "UltraSPARC Iii"
    pfUltraSPARCIII             = 87 $= "UltraSPARC III"
    pfUltraSPARCIIIl            = 88 $= "UltraSPARC IIIi"
    # 89 Available for assignment
    # ...........................
    # 95 Available for assignment
    pf68040                         = 96  $= "68040 Family"
    pf68xxx                         = 97  $= "68xxx"
    pf68000                         = 98  $= "68000"
    pf68010                         = 99  $= "68010"
    pf68020                         = 100 $= "68020"
    pf68030                         = 101 $= "68030"
    pfAmdAthlonTMX4qc               = 102 $= "AMD Athlon(TM) X4 Quad-Core Processor Family"
    pfAmdOpteronTMx1000             = 103 $= "AMD Opteron(TM) X1000 Series Processor"
    pfAmdOpteronTMx2000             = 104 $= "AMD Opteron(TM) X2000 Series APU"
    pfAmdOpteronTMAs                = 105 $= "AMD Opteron(TM) A-Series Processor"
    pfAmdOpteronTMx3000             = 106 $= "AMD Opteron(TM) X3000 Series APU"
    pfAmdZen                        = 107 $= "AMD Zen Processor Family"
    # 108 Available for assignment
    # ............................
    # 111 Available for assignment
    pfHobbit                        = 112 $= "Hobbit Family"
    # 113 Available for assignment
    # ............................
    # 119 Available for assignment
    pfCrusoeTM5000                  = 120 $= "CrusoeTM TM5000 Family"
    pfCrusoeTM3000                  = 121 $= "CrusoeTM TM3000 Family"
    pfEfficeonTM8000                = 122 $= "EfficeonTM TM8000 Family"
    # 123 Available for assignment
    # ........................................
    # 127 Available for assignment
    pfWeitek                        = 128 $= "Weitek"
    # 129 Available for assignment
    pfItaniumTM                     = 130 $= "ItaniumTM processor"
    pfAmdAthlonTM64                 = 131 $= "AMD AthlonTM 64 Processor Family"
    pfAmdOpteronTM                  = 132 $= "AMD OpteronTM Processor Family"
    pfAmdSempronTM                  = 133 $= "AMD SempronTM Processor Family"
    pfAmdTurionTM64Mobile           = 134 $= "AMD TurionTM 64 Mobile Technology"
    pfDualCoreAmdOpteronTM          = 135 $= "Dual-Core AMD OpteronTM Processor Family"
    pfAmdAthlonTM64X2DualCore       = 136 $= "AMD AthlonTM 64 X2 Dual-Core Processor Family"
    pfAmdTurionTM64X2Mobile         = 137 $= "AMD TurionTM 64 X2 Mobile Technology"
    pfQuadCoreAmdOpteronTM          = 138 $= "Quad-Core AMD OpteronTM Processor Family"
    pf3rdGenAmdOpteronTM            = 139 $= "Third-Generation AMD OpteronTM Processor Family"
    pfAmdPhenomTMFXQuadCore         = 140 $= "AMD PhenomTM FX Quad-Core Processor Family"
    pfAmdPhenomTMX4QuadCore         = 141 $= "AMD PhenomTM X4 Quad-Core Processor Family"
    pfAmdPhenomTMX2DualCore         = 142 $= "AMD PhenomTM X2 Dual-Core Processor Family"
    pfAmdAthlonTMX2DualCore         = 143 $= "AMD AthlonTM X2 Dual-Core Processor Family"
    pfPARISC                        = 144 $= "PA-RISC Family"
    pfPARISC8500                    = 145 $= "PA-RISC 8500"
    pfPARISC8000                    = 146 $= "PA-RISC 8000"
    pfPARISC7300LC                  = 147 $= "PA-RISC 7300LC"
    pfPARISC7200                    = 148 $= "PA-RISC 7200"
    pfPARISC7200LC                  = 149 $= "PA-RISC 7100LC"
    pfPARISC7100                    = 150 $= "PA-RISC 7100"
    # 151-159 Available for assignment
    # ................................
    # 159 Available for assignment
    pfV30                           = 160 $= "V30 Family"
    pf4coreIntelXenon3200           = 161 $= "Quad-Core Intel® Xeon® processor 3200 Series"
    pf2coreIntelXenon3000           = 162 $= "Dual-Core Intel® Xeon® processor 3000 Series"
    pf4coreIntelXenon5300           = 163 $= "Quad-Core Intel® Xeon® processor 5300 Series"
    pf2coreIntelXenon5100           = 164 $= "Dual-Core Intel® Xeon® processor 5100 Series"
    pf2coreIntelXenon5000           = 165 $= "Dual-Core Intel® Xeon® processor 5000 Series"
    pf2coreIntelXenonLV             = 166 $= "Dual-Core Intel® Xeon® processor LV"
    pf2coreIntelXenonULV            = 167 $= "Dual-Core Intel® Xeon® processor ULV"
    pf2coreIntelXenon7100           = 168 $= "Dual-Core Intel® Xeon® processor 7100 Series"
    pf4coreIntelXenon5400           = 169 $= "Quad-Core Intel® Xeon® processor 5400 Series"
    pf4coreIntelXenon               = 170 $= "Quad-Core Intel® Xeon® processor"
    pf4coreIntelXenon5200           = 171 $= "Dual-Core Intel® Xeon® processor 5200 Series"
    pf4coreIntelXenon7200           = 172 $= "Dual-Core Intel® Xeon® processor 7200 Series"
    pf4coreIntelXenon7300           = 173 $= "Quad-Core Intel® Xeon® processor 7300 Series"
    pf4coreIntelXenon7400           = 174 $= "Quad-Core Intel® Xeon® processor 7400 Series"
    pfMultiCoreIntelXenon           = 175 $= "Multi-Core Intel® Xeon® processor 7400 Series"
    pfPentiumIIIXenon               = 176 $= "Pentium® III XeonTM processor"
    pfPentiumIIISpeedStep           = 177 $= "Pentium® III Processor with Intel® SpeedStepTM Technology"
    pfPentium4                      = 178 $= "Pentium® 4 Processor"
    pfIntelXenon                    = 179 $= "Intel® Xeon® processor"
    pfAS400                         = 180 $= "AS400 Family"
    pfIntelXenonMP                  = 181 $= "Intel® XeonTM processor MP"
    pfAmdAthlonTMXP                 = 182 $= "AMD AthlonTM XP Processor Family"
    pfAmdAthlonTMMP                 = 183 $= "AMD AthlonTM MP Processor Family"
    pfIntelItanium2                 = 184 $= "Intel® Itanium® 2 processor"
    pfIntelPentiumM                 = 185 $= "Intel® Pentium® M processor"
    pfIntelCeleronD                 = 186 $= "Intel® Celeron® D processor"
    pfIntelPentiumD                 = 187 $= "Intel® Pentium® D processor"
    pfIntelPentiumEE                = 188 $= "Intel® Pentium® Processor Extreme Edition"
    pfIntelCoreTmSolo               = 189 $= "Intel® CoreTM Solo Processor"
    pfReserved                      = 190 $= "Reserved" # *3
    pfIntelCoreTM2Duo               = 191 $= "Intel® CoreTM 2 Duo Processor"
    pfIntelCoreTM2Solo              = 192 $= "Intel® CoreTM 2 Solo processor"
    pfIntelCoreTM2Extr              = 193 $= "Intel® CoreTM 2 Extreme processor"
    pfIntelCoreTM2Quad              = 194 $= "Intel® CoreTM 2 Quad processor"
    pfIntelCoreTM2ExtrMob           = 195 $= "Intel® CoreTM 2 Extreme mobile processor"
    pfIntelCoreTM2DuoMob            = 196 $= "Intel® CoreTM 2 Duo mobile processor"
    pfIntelCoreTM2SoloMob           = 197 $= "Intel® CoreTM 2 Solo mobile processor"
    pfIntelCoreTMi7                 = 198 $= "Intel® CoreTM i7 processor"
    pfIntelCoreTMCeleron            = 199 $= "Dual-Core Intel® Celeron® processor"
    pfIBM390                        = 200 $= "IBM390 Family"
    pfG4                            = 201 $= "G4"
    pfG5                            = 202 $= "G5"
    pfG6                            = 203 $= "ESA/390 G6"
    pfZArchBase                     = 204 $= "z/Architecture base"
    pfIntelCoreTMi5                 = 205 $= "Intel® CoreTM i5 processor"
    pfIntelCoreTMi3                 = 206 $= "Intel® CoreTM i3 processor"
    pfIntelCoreTMi9                 = 207 $= "Intel® CoreTM i9 processor"
    # D0h-D1h 208-209 Available for assignment
    pfViaC7TMm                      = 210 $= "VIA C7TM-M Processor Family"
    pfViaC7TMd                      = 211 $= "VIA C7TM-D Processor Family"
    pfViaC7TM                       = 212 $= "VIA C7TM Processor Family"
    pfViaEdenTM                     = 213 $= "VIA EdenTM Processor Family"
    pfMultiCoreIntelXeon            = 214 $= "Multi-Core Intel® Xeon® processor"
    pfDualCoreIntelXeon3xxx         = 215 $= "Dual-Core Intel® Xeon® processor 3xxx Series"
    pfQuadCoreIntelXeon3xxx         = 216 $= "Quad-Core Intel® Xeon® processor 3xxx Series"
    pfViaNanoTM                     = 217 $= "VIA NanoTM Processor Family"
    pfDualCoreIntelXeon5xxx         = 218 $= "Dual-Core Intel® Xeon® processor 5xxx Series"
    pfQuadCoreIntelXeon5xxx         = 219 $= "Quad-Core Intel® Xeon® processor 5xxx Series"
    # DCh 220 Available for assignment
    pfDualCoreIntelXenon7xxx        = 221 $= "Dual-Core Intel® Xeon® processor 7xxx Series"
    pfQuadCoreIntelXenon7xxx        = 222 $= "Quad-Core Intel® Xeon® processor 7xxx Series"
    pfMultiCoreIntelXenon7xxx       = 223 $= "Multi-Core Intel® Xeon® processor 7xxx Series"
    pfMultiCoreIntelXenon3400       = 224 $= "Multi-Core Intel® Xeon® processor 3400 Series"
    # E1h-E3h 225-227 Available for assignment
    pfAmdOpteronTM3000              = 228 $= "AMD OpteronTM 3000 Series Processor"
    pfAmdSempronTMII                = 229 $= "AMD SempronTM II Processor"
    pfEmbAmdOpteronTMQuadCore       = 230 $= "Embedded AMD OpteronTM Quad-Core Processor Family"
    pfAmdPhenomTMTripleCore         = 231 $= "AMD PhenomTM Triple-Core Processor Family"
    pfAmdTurionTMUltraDualCoreMob   = 232 $= "AMD TurionTM Ultra Dual-Core Mobile Processor Family"
    pfAmdTurionTMDualCoreMob        = 233 $= "AMD TurionTM Dual-Core Mobile Processor Family"
    pfAmdAthlonTMDualCore           = 234 $= "AMD AthlonTM Dual-Core Processor Family"
    pfAmdSempronTMSI                = 235 $= "AMD SempronTM SI Processor Family"
    pfAmdPhenomTMII                 = 236 $= "AMD PhenomTM II Processor Family"
    pfAmdAthlonTMII                 = 237 $= "AMD AthlonTM II Processor Family"
    pfAmdSixCoreOpteronTM           = 238 $= "Six-Core AMD OpteronTM Processor Family"
    pfAmdSempronTMM                 = 239 $= "AMD SempronTM M Processor Family"
    # 240-249 Available for assignment
    pfi860                          = 250  $= "i860"
    pfi960                          = 251  $= "i960"
    # 252-253 Available for assignment
    pfUseByte2                      = 254 # Indicator to obtain the processor family from the Processor Family 2 field
    pfReserved2                     = 255 $= "Reserved"
    # 256-511 These values are available for assignment, except for the following:
    pfARMv7                         = 256 $= "ARMv7"
    pfARMv8                         = 257 $= "ARMv8"
    pfSH3                           = 260 $= "SH-3"
    pfSH4                           = 261 $= "SH-4"
    pfArm                           = 280 $= "ARM"
    pfStrongARM                     = 281 $= "StrongARM"
    pf6x86                          = 300 $= "6x86"
    pfMediaGX                       = 301 $= "MediaGX"
    pfMII                           = 302 $= "MII"
    pfWinChip                       = 320 $= "WinChip"
    pfDsp                           = 350 $= "DSP"
    pfVideoPro                      = 500 $= "Video Processor"
    pfRISCVRV32                     = 512 $= "RISC-V RV32"
    pfRISCVRV64                     = 513 $= "RISC-V RV64"
    pfRISCVRV128                    = 514 $= "RISC-V RV128"
    # 515 Available for assignment
    # .............................
    # 65533 Available for assignment
    # FFFEh-FFFFh 65534-65535 Reserved
    #! - *1 Note that the meaning associated with this value is different from the meaning defined in CIM_Processor.Family for the same
    #! -    value.
    #
    #! - *2 Some version 2.0 specification implementations used Processor Family type value 30h to represent a Pentium® Pro
    #! -    processor.
    #
    #! - *3 Version 2.5 of this specification listed this value as “available for assignment”. CIM_Processor.mof files assigned this value to
    #! -    AMD K7 processors in the CIM_Processor.Family property, and an SMBIOS change request assigned it to Intel Core 2
    #! -    processors. Some implementations of the SMBIOS version 2.5 specification are known to use BEh to indicate Intel Core 2
    #! -    processors. Some implementations of SMBIOS and some implementations of CIM-based software may also have used BEh
    #! -    to indicate AMD K7 processors.

smbEnum ProcessorStatus:
    psUnknown               $= "Unknown"
    psEnabled               $= "CPU Enabled"
    psDisabledUser          $= "CPU Disabled by User through BIOS Setup"
    psBiosDisabled          $= "CPU Disabled By BIOS (POST Error)"
    psIdle                  $= "CPU is Idle, waiting to be enabled."
    psReserved5h            $= "Reserved"
    psReserved6h            $= "Reserved"
    psOther                 $= "Other"

smbEnum ProcessorUpgrade:
    puNotset                $= "Notset"
    puOther                 $= "Other"
    puUnknown               $= "Unknown"
    puDaughterBoard         $= "Daughter Board"
    puZIFSoc                $= "ZIF Socket"
    puReplaceablePiggyBack  $= "Replaceable Piggy Back"
    puNone                  $= "None"
    puLIFSoc                $= "LIF Socket"
    puSlot1                 $= "Slot 1"
    puSlot2                 $= "Slot 2"
    pu370pinSoc             $= "370-pin socket"
    puSlotA                 $= "Slot A"
    puSlotM                 $= "Slot M"
    puSoc423                $= "Socket 423"
    puSocA462               $= "Socket A (Socket 462)"
    puSoc478                $= "Socket 478"
    puSoc754                $= "Socket 754"
    puSoc940                $= "Socket 940"
    puSoc939                $= "Socket 939"
    puSocMPGA604            $= "Socket mPGA604"
    puSocLGA771             $= "Socket LGA771"
    puSocLGA775             $= "Socket LGA775"
    puSocS1                 $= "Socket S1"
    puSocAM2                $= "Socket AM2"
    puSocF1207              $= "Socket F (1207)"
    puSocLGA1366            $= "Socket LGA1366"
    puSocG34                $= "Socket G34"
    puSocAM3                $= "Socket AM3"
    puSocC32                $= "Socket C32"
    puSocLGA1156            $= "Socket LGA1156"
    puSocLGA1567            $= "Socket LGA1567"
    puSocPGA988A            $= "Socket PGA988A"
    puSocBGA1288            $= "Socket BGA1288"
    puSocrPGA988B           $= "Socket rPGA988B"
    puSocBGA1023            $= "Socket BGA1023"
    puSocBGA1224            $= "Socket BGA1224"
    puSocLGA1155            $= "Socket LGA1155"
    puSocLGA1356            $= "Socket LGA1356"
    puSocLGA2011            $= "Socket LGA2011"
    puSocFS1                $= "Socket FS1"
    puSocFS2                $= "Socket FS2"
    puSocFM1                $= "Socket FM1"
    puSocFM2                $= "Socket FM2"
    puSocLGA20113           $= "Socket LGA2011-3"
    puSocLGA13563           $= "Socket LGA1356-3"
    puSocLGA1150            $= "Socket LGA1150"
    puSocBGA1168            $= "Socket BGA1168"
    puSocBGA1234            $= "Socket BGA1234"
    puSocBGA1364            $= "Socket BGA1364"
    puSocAM4                $= "Socket AM4"
    puSocLGA1151            $= "Socket LGA1151"
    puSocBGA1356            $= "Socket BGA1356"
    puSocBGA1440            $= "Socket BGA1440"
    puSocBGA1515            $= "Socket BGA1515"
    puSocLGA36471           $= "Socket LGA3647-1"
    puSocSP3                $= "Socket SP3"
    puSocSP3r2              $= "Socket SP3r2"
    puSocLGA2066            $= "Socket LGA2066"
    puSocBGA1392            $= "Socket BGA1392"
    puSocBGA1510            $= "Socket BGA1510"
    puSocBGA1528            $= "Socket BGA1528"
    puSocLGA4189            $= "Socket LGA4189"
    puSocLGA1200            $= "Socket LGA1200"

smbEnum ProcessorFeature:
    pfcReserved                 $= "Reserved"
    pfcUnknown                  $= "Unknown"
    pfc64bitCapable             $= "64-bit Capable"
    pfcMultiCore                $= "Multi-Core"
    pfcHardwareThread           $= "Hardware Thread"
    pfcExecuteProtection        $= "Execute Protection"
    pfcEnhancedVirtualization   $= "Enhanced Virtualization"
    pfcPowerPerformanceControl  $= "Power/Performance Control"
    pfc128bitCapable            $= "128-bit Capable"
    pfcArm64SoCID               $= "Arm64 SoC ID"