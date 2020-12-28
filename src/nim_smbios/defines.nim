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
  linuxSMBIOSRawAddress* = 0x000F0000
  linuxSMBIOSRawEndAddres* = 0x000fffff
  linuxDevMem* = "/dev/mem"
  linuxDMISysfsPath* = "/sys/firmware/dmi/tables/DMI"
  linuxDMISysfsEntryPoint* = "/sys/firmware/dmi/tables/smbios_entry_point"