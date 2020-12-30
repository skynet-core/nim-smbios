import guid

const
  magicPrefix* = "_SM"
  magicPrefix32* = "_SM_"
  magicPrefix64* = "_SM3_"
  magicPrefixDMI* = "_DMI_"
  null*: char = '\0'
  endString*: array[2,char] = ['\0','\0']
  outOfSpec* = "Not Specified"
  ioSMBIOSClassName* = "AppleSMBIOS"
  ioSMBIOSPropertyName* = "SMBIOS"
  ioSMBIOSEPSPropertyName* = "SMBIOS-EPS"
  linuxSMBIOSRawAddress* = 0x000F_0000
  linuxSMBIOSRawEndAddres* = 0x000F_FFFF
  linuxDevMem* = "/dev/mem"
  linuxDMISysfsPath* = "/sys/firmware/dmi/tables/DMI"
  linuxDMISysfsEntryPoint* = "/sys/firmware/dmi/tables/smbios_entry_point"
  smb3Guid* = initGuid(0xf2fd1544'u32, 0x9794'u16, 0x4a2c'u16, 0x99, 0x2e, 0xe5, 0xbb, 0xcf, 0x20, 0xe3, 0x94)
  smbGuid*  = initGuid(0xeb9d2d31'u32, 0x2d88'u16, 0x11d3'u16, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d)