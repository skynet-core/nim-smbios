type
    GUID* = array[16, uint8]


proc newGuid*(): GUID =
    zeroMem(addr result, 16)
    return

proc initGuid*(a: uint32, b: uint16,c: uint16,d0,d1,d2,d3,d4,d5,d6,d7: uint8): GUID =
        result = [(a and 0xff).uint8,
                    ((a shr 8) and 0xff).uint8,
                    ((a shr 16) and 0xff).uint8,
                    ((a shr 24) and 0xff).uint8,
                    (b and 0xff).uint8,
                    ((b shr 8) and 0xff).uint8,
                    (c and 0xff).uint8,
                    ((c shr 8) and 0xff).uint8,
                    d0, d1, d2, d3, d4, d5, d6, d7]