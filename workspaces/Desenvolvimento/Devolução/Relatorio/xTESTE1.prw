#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - PDF ESPELHO
PDF ESPELHO
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     25/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------
 
USER FUNCTION xTESTE1()

    LOCAL lAdjustToLegacy := .F.
    LOCAL lDisableSetup   := .T.
    LOCAL cLocal          := "\spool"
    LOCAL cQuery          := ""
    LOCAL cQuery1         := ""
    LOCAL cQuery2         := ""
    LOCAL nVert           := 328
    LOCAL nVert1          := 330
    LOCAL nHori           := 320
    LOCAL oPrinter

    oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
    oFont    := TFont():New("Arial",,9,.T.)

    cQuery := " SELECT " + CRLF
    cQuery += " A.[ZA3_NUM], " + CRLF
    cQuery += " A.[ZA3_CGCESP], " + CRLF
	cQuery += " A.[ZA3_NOMEES], " + CRLF
	cQuery += " A.[ZA3_ENDESP], " + CRLF
	cQuery += " A.[ZA3_MUNESP], " + CRLF
	cQuery += " A.[ZA3_ESTESP], " + CRLF
	cQuery += " A.[ZA3_INSCES], " + CRLF
    cQuery += " B.[ZA4_DOCESP], " + CRLF
    cQuery += " A.[ZA3_DTEMIS], " + CRLF
	cQuery += " SUM(B.[ZA4_PRCESP] * B.[ZA4_QTDESP] + B.[ZA4_VIPIES]) AS TOTAL " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZA3") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("ZA4") + " B " + CRLF
    cQuery += " ON A.[ZA3_NUM] = B.[ZA4_NUM] " + CRLF
    cQuery += " WHERE A.[ZA3_NUM] = '60000000' " + CRLF
    cQuery += " GROUP BY A.[ZA3_NUM], " + CRLF
    cQuery += " A.[ZA3_CGCESP], " + CRLF
	cQuery += " A.[ZA3_NOMEES], " + CRLF
	cQuery += " A.[ZA3_ENDESP], " + CRLF
	cQuery += " A.[ZA3_MUNESP], " + CRLF
	cQuery += " A.[ZA3_ESTESP], " + CRLF
	cQuery += " A.[ZA3_INSCES], " + CRLF
    cQuery += " A.[ZA3_DTEMIS], " + CRLF
	cQuery += " B.[ZA4_DOCESP] "

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

    WHILE (cAlias)->(!EOF())
        oPrinter:STARTPAGE()
        oPrinter:BOX(20,5,70,100,"-5")
        oPrinter:SAYBITMAP(28,9,"tmp\logo_novo.png",90,28)
        oPrinter:BOX(20,100,70,500,"-5")
        oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLUÇÃO",oFont)
        oPrinter:BOX(20,500,70,590,"-5")
        oPrinter:SAY(35,505,"PROTOCOLO",oFont)
        oPrinter:SAY(50,505,(cAlias)->ZA3_NUM,oFont)
        oPrinter:SAY(65,505,(cAlias)->ZA3_DTEMIS,oFont)
        oPrinter:SAY(90,10,"1 - Remetente",oFont)
        oPrinter:BOX(150,5,100,590,"-5")
        oPrinter:SAY(110,10,"CNPJ/CPF: "+(cAlias)->ZA3_CGCESP+"",oFont)
        oPrinter:SAY(120,10,"NOME/RAZÃO SOCIAL: "+(cAlias)->ZA3_NOMEES+"",oFont)
        oPrinter:SAY(130,10,"ENDEREÇO: "+ALLTRIM((cAlias)->ZA3_ENDESP)+" - "+ALLTRIM((cAlias)->ZA3_MUNESP)+" - "+ALLTRIM((cAlias)->ZA3_ESTESP)+"",oFont)
        oPrinter:SAY(140,10,"INSCRIÇÃO ESTADUAL: "+(cAlias)->ZA3_INSCES+"",oFont)
        oPrinter:SAY(170,10,"2 - Natureza de Operação",oFont)
        oPrinter:BOX(180,5,200,590,"-5")
        oPrinter:SAY(193,10,"Devolução",oFont)
        oPrinter:SAY(220,10,"3 - Destinatário",oFont)
        oPrinter:BOX(230,5,280,590,"-5")
        oPrinter:SAY(300,10,"4 - Dados do Produto",oFont)
        oPrinter:BOX(310,5,320,590,"-5")
        oPrinter:SAY(318,10,"ITEM",oFont)
        oPrinter:SAY(318,40,"DESCRIÇÃO DO PRODUTO",oFont)
        oPrinter:SAY(318,175,"CL FISCAL",oFont)
        oPrinter:SAY(318,215,"CFOP",oFont)
        oPrinter:SAY(318,240,"UM",oFont)
        oPrinter:SAY(318,255,"QTDE",oFont)
        //oPrinter:SAY(318,300,"VL UNIT",oFont)
        //oPrinter:SAY(318,335,"VL TOTAL",oFont)
        //oPrinter:SAY(318,375,"BASE ICMS",oFont)
        //oPrinter:SAY(318,420,"VL ICMS",oFont)
        //oPrinter:SAY(318,455,"VL IPI",oFont)
        //oPrinter:SAY(318,480,"% ICMS",oFont)
        //oPrinter:SAY(318,510,"% IPI",oFont)
        //oPrinter:SAY(318,535,"BASE ST",oFont)
        
        cQuery1 := " SELECT " + CRLF
        cQuery1 += " B.[ZA4_PRODES], " + CRLF
        cQuery1 += " SUBSTRING(B.[ZA4_DESCES],1,31) AS [ZA4_DESCES], " + CRLF
        cQuery1 += " B.[ZA4_CLFIES], " + CRLF
        cQuery1 += " D.[ZA2_CFOPIM], " + CRLF
        cQuery1 += " B.[ZA4_UMESPE], " + CRLF
        cQuery1 += " B.[ZA4_QTDESP], " + CRLF
        cQuery1 += " B.[ZA4_PRCESP], " + CRLF
        cQuery1 += " B.[ZA4_PRCESP] * B.[ZA4_QTDESP] AS [ZA4_TLESPE], " + CRLF
        cQuery1 += " B.[ZA4_BICMES] * B.[ZA4_QTDESP] AS [ZA4_BICMES], " + CRLF
        cQuery1 += " B.[ZA4_BICMES] * B.[ZA4_PICMES] AS [ZA4_VICMES], " + CRLF
        cQuery1 += " B.[ZA4_PRCESP] * B.[ZA4_IPIESP] AS [ZA4_VIPIES], " + CRLF
        cQuery1 += " B.[D2_PICMES], " + CRLF
	    cQuery1 += " B.[ZA4_IPIESP], " + CRLF
	    cQuery1 += " CASE " + CRLF
	    cQuery1 += " WHEN A.[ZA3_ST] = '2' THEN '0' " + CRLF
	    cQuery1 += " ELSE B.[ZA4_BRICES] " + CRLF
	    cQuery1 += " END AS [ZA4_BRICES], " + CRLF
	    cQuery1 += " B.[ZA4_ICRETE], " + CRLF
	    cQuery1 += " B.[ZA4_MARESP], " + CRLF
        cQuery1 += " B.[ZA4_DTEMIS] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("ZA3") + " A " + CRLF  
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA4") + " B " + CRLF 
        cQuery1 += " ON A.[ZA3_NUM] = B.[ZA4_NUM]
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery1 += " ON B.[ZA4_NF] = C.[D2_DOC] AND B.[ZA4_SERESP] = C.[D2_SERIE] AND B.[ZA4_PROD] = C.[D2_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA2") + " D " + CRLF
        cQuery1 += " ON C.[D2_TES] = E.[ZA2_TESSAI] " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZA3_NUM] = '60000000'"

        cQuery1 := CHANGEQUERY(cQuery1)
        cAlias1 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAlias1,.F.,.T.)

        WHILE (cAlias1)->(!Eof())
            IF (cAlias)->ZZY_NF == (cAlias1)->ZZY_NF
                oPrinter:BOX(nVert1,5,nHori,590,"-5")
                oPrinter:SAY(nVert,10,(cAlias1)->ZZY_PROD,oFont)
                oPrinter:SAY(nVert,40,(cAlias1)->B1_DESC,oFont)
                oPrinter:SAY(nVert,175,(cAlias1)->B1_POSIPI,oFont)
                oPrinter:SAY(nVert,215,"5201",oFont)
                oPrinter:SAY(nVert,240,(cAlias1)->D2_UM,oFont)
                oPrinter:SAY(nVert,250,STR((cAlias1)->ZZY_QTD,6),oFont)
                //oPrinter:SAY(nVert,292,STR((cAlias1)->D2_PRCVEN,10,2),oFont)
                //oPrinter:SAY(nVert,330,STR((cAlias1)->D2_TOTAL,10,2),oFont)
                //oPrinter:SAY(nVert,376,STR((cAlias1)->D2_BASEICM,10,2),oFont)
                //oPrinter:SAY(nVert,415,STR((cAlias1)->D2_VALICM,10,2),oFont)
                //oPrinter:SAY(nVert,446,STR((cAlias1)->D2_VALIPI,10,2),oFont) 
                //oPrinter:SAY(nVert,475,STR((cAlias1)->D2_PICM,10,2),oFont)
                //oPrinter:SAY(nVert,500,STR((cAlias1)->D2_IPI,10,2),oFont)
                //oPrinter:SAY(nVert,520,STR((cAlias1)->D2_BRICMS,10,2),oFont)
                nVert  += 10
                nVert1 += 10
                nHori  += 10
            ENDIF
        (cAlias1)->(DBSKIP())    
        ENDDO

        nVert2 := nVert1 += 15
        nVert3 := nVert  += 1
        nVert4 := nVert  += 10
        nVert5 := nVert1 += 20
        oPrinter:BOX(nVert2,5,nHori,590,"-5")
        oPrinter:SAY(nVert3,10,"BASE CALCULO ICMS")
        oPrinter:SAY(nVert4,10,"TESTE",oFont)
        oPrinter:SAY(nVert3,110,"TOTAL ICMS")
        oPrinter:SAY(nVert4,110,"TESTE",oFont)
        oPrinter:SAY(nVert3,180,"BASE CÁLCULO ICMS ST")
        oPrinter:SAY(nVert4,180,"TESTE",oFont)
        oPrinter:SAY(nVert3,290,"TOTAL ICMS ST")
        oPrinter:SAY(nVert4,290,"TESTE",oFont)
        oPrinter:SAY(nVert3,370,"TOTAL DOS PRODUTOS")
        oPrinter:SAY(nVert4,370,"TESTE",oFont)
        oPrinter:SAY(nVert3,470,"TOTAL IPI")
        oPrinter:SAY(nVert4,470,"TESTE",oFont)
        oPrinter:SAY(nVert3,520,"TOTAL DA NOTA")
        oPrinter:SAY(nVert4,495,STR((cAlias)->TOTAL),oFont)
        oPrinter:SAY(nVert5,10,"5 - Informações Adicionais",oFont)
        nVert6  := nVert5 + 10
        nVert7  := nVert5 + 20
        nVert8  := nVert5 + 30
        nVert9  := nVert5 + 40
        nVert10 := nVert5 + 50
        nHori1  := nHori  + 100
        oPrinter:BOX(nVert6,5,nHori1,590,"-5")
        oPrinter:SAY(nVert7,7," ATENÇÃO: ESTE PROTOCOLO TEM VALIDADE DE 90 DIAS. APÓS ESTE PERÍODO, O MESMO SERÁ CANCELADO. ",oFont)
        oPrinter:SAY(nVert8,7," A NF DE DEVOLUÇÃO DEVERÁ SER ENVIADA PARA CONFERÊNCIA DA ALUMBRA NO PRAZO DE 12 HORAS APÓS A SUA EMISSÃO, ",oFont)
        oPrinter:SAY(nVert9,7," UMA VEZ QUE SE FOR NECESSÁRIO O CANCELAMENTO DA MESMA, O CLIENTE TERÁ O PRAZO DE 24HORAS. ",oFont)
        oPrinter:SAY(nVert10,7," Modelo de nota fiscal de devolução referente a(s) NF(s): ",oFont)
        nVert11 := nVert10 += 5
        nVert12 := nVert10 += 7
        nHori2  := nHori1  += 10
        oPrinter:BOX(nVert11,5,nHori2,590,"-5")
        oPrinter:SAY(nVert12,10,"SERIE")
        oPrinter:SAY(nVert12,60,"NF-E")
        oPrinter:SAY(nVert12,110,"DATA DE EMISSÃO")
        oPrinter:SAY(nVert12,210,"CHAVE NF-E")
        nVert13 := nVert12 += 10
        nHori3  := nHori2  += 0
        nVert14 := nVert13 += 0

        cQuery2 := " SELECT D.[F2_SERIE], " + CRLF
        cQuery2 += " D.[F2_DOC], " + CRLF
        cQuery2 += " C.[D2_ITEM], " + CRLF
        cQuery2 += " FORMAT(CONVERT(DATE, D.[F2_EMISSAO]), 'dd/MM/yyyy') AS [EMISSAO], " + CRLF
	    cQuery2 += " D.[F2_CHVNFE], " + CRLF
        cQuery2 += " A.[ZZW_NUM], " + CRLF
        cQuery2 += " B.[ZZY_NUM], " + CRLF
        cQuery2 += " B.[ZZY_NF] " + CRLF
        cQuery2 += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
        cQuery2 += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
        cQuery2 += " ON A.[ZZW_NUM] = B.[ZZY_NUM]
        cQuery2 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery2 += " ON B.[ZZY_NF] = C.[D2_DOC] AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD]" + CRLF
        cQuery2 += " LEFT JOIN " + RETSQLNAME("SF2") + " D " + CRLF 
        cQuery2 += " ON B.[ZZY_NF] = D.[F2_DOC] AND B.[ZZY_SERIE] = D.[F2_SERIE] " + CRLF
        cQuery2 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000000'" + CRLF

        cQuery2 := CHANGEQUERY(cQuery2)
        cAlias2 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery2),cAlias2,.F.,.T.)

            WHILE (cAlias2)->(!Eof())
                IF (cAlias)->ZZY_NF == (cAlias2)->ZZY_NF
                    oPrinter:BOX(nVert13,5,nHori3,590,"-5")
                    oPrinter:SAY(nVert14,10,(cAlias2)->F2_SERIE)
                    oPrinter:SAY(nVert14,50,(cAlias2)->F2_DOC)
                    oPrinter:SAY(nVert14,100,(cAlias2)->EMISSAO)
                    oPrinter:SAY(nVert14,210,(cAlias2)->F2_CHVNFE)
                    nVert13 += 7
                    nVert14 += 7
                    nHori3  += 7
                ENDIF

                (cAlias2)->(DBSKIP()) 
            ENDDO

            (cAlias2)->(DBCLOSEAREA())

        (cAlias1)->(DBCLOSEAREA())      

        oPrinter:ENDPAGE()
        nVert   := 328
        nVert1  := 330
        nHori   := 320
        nVert2  := NIL
        nVert3  := NIL
        nVert4  := NIL
        nVert5  := NIL
        nVert6  := NIL
        nVert7  := NIL
        nVert8  := NIL
        nVert9  := NIL
        nVert10 := NIL
        nVert11 := NIL
        nVert12 := NIL
        nVert13 := NIL
        nVert14 := NIL
        nHori3  := NIL

       (cAlias)->(DBSKIP()) 
    ENDDO

    (cAlias)->(DBCLOSEAREA()) 

    oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    ENDIF 
RETURN 

    //oPrinter:SAY(319,470,"BASE ST",oFont1)
    //oPrinter:SAY(319,490,"VL ST",oFont1)
    //oPrinter:SAY(319,510,"MVA",oFont1)
