import unittest, os, marshal, options

import nim_smbios/private/defines
import nim_smbios

test "test parser":
  let entryFilePath = joinPath(getCurrentDir(), "rsc","Acer_Predator_PT515-51.entry")
  let tableFilePath = joinPath(getCurrentDir(), "rsc","Acer_Predator_PT515-51.table")
  var tableParser = newParser(entryFilePath,tableFilePath)
  discard tableParser.parseTable()

  var opt = tableParser.structs(dtBios.uint8)
  assert opt.isSome()
  let bios = cast[BiosInfo](opt.unsafeGet[0])
  assert bios.biosVersion == "V1.13"
  opt = tableParser.structs(dtSystem.uint8)
  assert opt.isSome()
  let system = cast[SystemInfo](opt.unsafeGet[0])
  assert system.manufacturer == "Acer"
  opt = tableParser.structs(dtBaseBoard.uint8)
  assert opt.isSome()
  let board = cast[BaseBoard](opt.unsafeGet[0])
  assert board.product == "Ghibli_CFS"
  opt = tableParser.structs(dtChasis.uint8)
  assert opt.isSome()
  let chassis = cast[Chassis](opt.unsafeGet[0])
  assert chassis.kind == ctNotebook
  opt = tableParser.structs(dtProcessor.uint8)
  assert opt.isSome()
  let cpu = cast[Processor](opt.unsafeGet[0])
  assert cpu.upgrade == puSocBGA1440

