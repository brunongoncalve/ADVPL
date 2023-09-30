#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

USER FUNCTION MODELO2()

    LOCAL oReport
    LOCAL cPerg := "RELATO"

    PERFUNTE(cPerg, .F.)

    oReport := REPORTDEF(cPerg)
    oReport:PRINTDIALOG()

RETURN NIL

STATIC FUNCTION REPORTDEF(cPerg)

    LOCAL oReport
    LOCAL oSection1
    LOCAL oSection2
    LOCAL oSection3
    LOCAL cTitulo := "PEDIDOS POR CLIENTES"

    oReport := TREPORT():NEW("RELATO", cTitulo, cPerg, {|oReport| REPORTPRINT(oReport)})
    oReport:SETLANDSCAPE()

    oSection1 := TRSECTION():NEW(oReport, "CLIENTES")

    TRCELL():NEW(oSection1, "A1_COD" , , "COD.CLIENTE" , "", TAMSX3("A1_COD")[1])
    TRCELL():NEW(oSection1, "A1_LOJA" , , "LOJA" , "" ,TAMSX3("A1_LOJA")[1])
    TRCELL():NEW(oSection1, "A1_NOME" , , "NOME" , "", TAMSX3("A1_NOME")[1])
    
    oSection2 := TRSECTION():NEW(oReport, "PEDIDOS")

    TRCELL():NEW(oSection2, "C5_NUM" , , "NUMERO PEDIDO" , "", TAMSX3("C5_NUM")[1])

    oSection3 := TRSECTION():NEW(oReport, "ITENS")

    TRCELL():NEW(oSection3, "C6_NUM" , , "NUMERO ITENS" , "", TAMSX3("C6_NUM")[1])

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL oSection3 := oReport:SECTION(3)
    LOCAL cAliasCL  := GETNEXTALIAS()
    LOCAL cAliasPD  := GETNEXTALIAS()
    LOCAL cAliasIT  := GETNEXTALIAS()
    LOCAL nRegs     := 0
    
    BEGINSQL ALIAS cAliasCL
        SELECT SA1.[A1_COD],
               SA1.[A1_LOJA],
               SA1.[A1_NOME]
        FROM %TABLE:SA1% AS SA1 
        WHERE SA1.%NOTDEL%
        AND [A1_FILIAL] = %XFILIAL:SA1%
        AND [A1_COD] BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR03%
        AND [A1_LOJA] BETWEEN %EXP:MV_PAR02% AND %EXP:MV_PAR04%
    ENDSQL

    COUNT TO nRegs
        IF nRegs > 0
            (cAliasCL)->(DBGOTOP())
                WHILE (cAliasCL)->(!EOF())
                    oSection1:INIT()

                    oSection1:CELL("A1_COD"):SETVALUE(ALLTRIM((cAliasCL)->A1_COD))
                    oSection1:CELL("A1_LOJA"):SETVALUE(ALLTRIM((cAliasCL)->A1_LOJA))
                    oSection1:CELL("A1_NOME"):SETVALUE(ALLTRIM((cAliasCL)->A1_NOME))

                    oSection1:PRINTLINE()
                    oReport:THINLINE()
        
                    BEGINSQL ALIAS cAliasPD
                        SELECT [C5_NUM]
                        FROM %TABLE:SC5% AS SC5
                        WHERE SC5.%NOTDEL%
                        AND SC5.C5_CLIENTE = %EXP:(cAliasCL)->A1_COD%
                        AND SC5.C5_LOJACLI = %EXP:(cAliasCL)->A1_LOJA%
                    ENDSQL

                        nRegs := 0

                        COUNT TO nRegs
                            IF nRegs > 0
                                (cAliasPD)->(!EOF())
                                    WHILE (cAliasCL)->(!EOF())
                                        oSection2:INIT()

                                        oSection2:CELL("C5_NUM"):SETVALUE(ALLTRIM((cAliasPD)->C5_NUM))

                                        oSection2:PRINTLINE()
                                        //oReport:THINLINE()

                                        BEGINSQL ALIAS cAliasIT
                                            SELECT SC6.[C6_PRODUTO],
                                                   SC6.[C6_QTDVEN],
                                                   SC6.[C6_VALOR]
                                            FROM %TABLE:SC6% AS SC6
                                            WHERE SC6.%NOTDEL%
                                            AND SC6.C6_NUM = %EXP:(cAliasPD)->C5_NUM% 
                                        ENDSQL

                                        nRegs := 0

                                        COUNT TO nRegs
                                            IF nRegs > 0
                                                (cAliasIT)->(!EOF())
                                                    WHILE (cAliasIT)->(!EOF())
                                                        oSection3:INIT()

                                                        oSection3:CELL("C6_PRODUTO"):SETVALUE(ALLTRIM((cAliasIT)->C6_PRODUTO))

                                                        oSection3:PRINTLINE()

                                                        (cAliasIT)->(DBSKIP())
                                                    ENDDO

                                                    oSection3:FINISH()
                                                    oReport:SKIPLINE(1)
                                            ENDIF        

                                        oSection2:FINISH()
                                        (cAliasIT)->(DBCLOSEAREA())

                                        (cAliasIT)->(DBSKIP())

                                    ENDDO

                            ENDIF

                            (cAliasPD)->(DBCLOSEAREA())

                            (cAliasCL)->(DBSKIP())
                            oReport:SKIPLINE(2)
                            oSection1:FINISH()   

                ENDDO
        ENDIF

        (cAliasCL)->(DBCLOSEAREA())

RETURN  
