import unittest, os, marshal

import nim_smbios/private/defines
import nim_smbios

test "test parser":
  let entryFilePath = joinPath(getCurrentDir(), "rsc","Acer_Predator_PT515-51.entry")
  let tableFilePath = joinPath(getCurrentDir(), "rsc","Acer_Predator_PT515-51.table")
  var tableParser = newParser(entryFilePath,tableFilePath)
  discard tableParser.parseTable()

  echo $$tableParser.structs(DataType.dtSystem.uint8)