import macros, options

type EnumRecord* = tuple[
        name: NimNode, 
        value: Option[NimNode],
        repr: NimNode,
    ]

proc record*(asgn: NimNode): EnumRecord =
    case asgn.kind
    of nnkIdent:
        result = (name: asgn,value: none[NimNode](),repr: asgn)
    of nnkAsgn:
        asgn[0].expectKind nnkIdent
        assert asgn.len == 2
        case asgn[1].kind
        of nnkInfix:
            asgn[1][0].expectKind nnkIdent
            asgn[1][1].expectKind nnkIntLit
            asgn[1][2].expectKind nnkStrLit
            assert asgn[1].len == 3
            assert asgn[1][0].strVal == "$="
            result = (name: asgn[0],value: some[NimNode](asgn[1][1]),repr: asgn[1][2])
        of nnkIntLit:
            result = (name: asgn[0],value: some[NimNode](asgn[1]),repr: asgn[0])
        else: discard
    of nnkInfix:
        asgn[0].expectKind nnkIdent
        asgn[1].expectKind nnkIdent
        asgn[2].expectKind nnkStrLit
        assert asgn[0].strVal == "$="
        result = (name: asgn[1] ,value: none[NimNode](), repr: asgn[2])
    else: discard

proc toRecords(stmtList: NimNode): seq[EnumRecord] =
    stmtList.expectKind nnkStmtList
    result = newSeq[EnumRecord]()
    for child in stmtList:
        child.expectKind {nnkIdent, nnkAsgn, nnkInfix}
        result.add(child.record)


proc toEnumRecords(list: seq[EnumRecord]): seq[NimNode] =
    result = newSeq[NimNode](list.len)
    for (i,rr) in list.pairs:
        if rr.value.isSome:
            result[i]= newTree(nnkEnumFieldDef,rr.name, rr.value.get)
        else:
            result[i] = rr.name

macro smbEnum*(name: untyped, values: untyped): untyped =
    name.expectKind nnkIdent
    values.expectKind nnkStmtList
    assert values.len > 0

    let records = toRecords(values)
    let enumRecords = toEnumRecords(records)
    var 
        recs = newTree(
                nnkEnumTy,
                newEmptyNode(),
            )
        cases = newTree(
                    nnkCaseStmt,
                    ident("v"),
                )
    for er in enumRecords:
        recs.add(er)
    
    for rr in records:
        cases.add(newTree(
                    nnkOfBranch,
                    rr.name,
                    newStmtList(newStrLitNode(rr.repr.strVal))
                )
            )

    result = newStmtList(
        newTree(
            nnkTypeSection,
            newTree(
                nnkTypeDef,
                newTree(
                    nnkPostfix,
                    ident("*"),
                    name,
                ),
                newEmptyNode(),
                recs
            )
        ),
        newTree(
            nnkProcDef,
            newTree(
                nnkPostfix,
                ident("*"),
                ident("repr")
            ),
            newEmptyNode(),
            newEmptyNode(),
            newTree(
                nnkFormalParams,
                ident("string"),
                newIdentDefs(ident("v"), name, newEmptyNode())
            ),
            newEmptyNode(),
            newEmptyNode(),
            newStmtList(
                cases
            )
        )
    )
