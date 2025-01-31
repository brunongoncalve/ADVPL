#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - PDF ESPELHO
PDF ESPELHO
@author    BRUNO
@since     25/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

    LOCAL lAdjustToLegacy := .F.
    LOCAL lDisableSetup   := .T.
    LOCAL cLocal          := "C:\Protocolo"
    LOCAL aArquivos       := {}
    LOCAL cQuery          := ""
    LOCAL cQuery1         := ""
    LOCAL cQuery2         := ""
    LOCAL cQuery3         := ""
    LOCAL nVert           := 328
    LOCAL nVert1          := 330
    LOCAL nHori           := 320
    LOCAL nProtoc         := ZZW->ZZW_NUM
    LOCAL nST             := ZZW_ST
    LOCAL oPrinter
    PRIVATE cServEmail    := GETMV("AL_SERVEMA")
    PRIVATE cLoginEmail   := GETMV("AL_LOGINEM")
    PRIVATE cPassEmail    := GETMV("AL_PASSEMA")
    PRIVATE cRespEmail    := GETMV("AL_RESEMAI")
    PRIVATE cEmailCC      := GETMV("AL_EMAILCC")

    cQuery := " SELECT " + CRLF
    cQuery += " A.[ZA3_NUM], " + CRLF
    cQuery += " C.[ZZW_MOTIVO], " + CRLF
    cQuery += " A.[ZA3_CGCESP], " + CRLF
	cQuery += " A.[ZA3_NOMEES], " + CRLF
	cQuery += " A.[ZA3_ENDESP], " + CRLF
	cQuery += " A.[ZA3_MUNESP], " + CRLF
	cQuery += " A.[ZA3_ESTESP], " + CRLF
	cQuery += " A.[ZA3_INSCES], " + CRLF
    cQuery += " B.[ZA4_DOCESP], " + CRLF
    cQuery += " C.[ZZW_VEND], " + CRLF
    cQuery += " D.[A3_EMAIL], " + CRLF
    cQuery += " D.[A3_NOME], " + CRLF
    cQuery += " FORMAT(CONVERT(DATE, A.[ZA3_DTEMIS]), 'dd/MM/yyyy') AS [EMISSAO], " + CRLF
    cQuery += " SUM(B.[ZA4_BICMES]) AS [A], " + CRLF
    cQuery += " ROUND(SUM(CAST(B.[ZA4_QTDESP] * B.[ZA4_PRCESP] * (B.[ZA4_PICMES] / 100) AS DECIMAL(10, 2))),2) AS [B], " + CRLF
    cQuery += " SUM(B.[ZA4_BRICES]) AS [C], " + CRLF
    cQuery += " SUM(B.[ZA4_ICRETE]) AS [D], " + CRLF
    cQuery += " SUM(B.[ZA4_QTDESP] * B.[ZA4_PRCESP]) AS [E], " + CRLF
    cQuery += " ROUND(SUM(CAST(B.[ZA4_QTDESP] * B.[ZA4_PRCESP] * (B.[ZA4_IPIESP] / 100) AS DECIMAL(10, 2))),2) AS [F], " + CRLF
    cQuery += " CASE " + CRLF
    cQuery += " WHEN A.[ZA3_ESTESP] = 'SP' THEN SUM(B.[ZA4_PRCESP] * B.[ZA4_QTDESP] + B.[ZA4_VIPIES] + B.[ZA4_ICRETE]) " + CRLF
    cQuery += " WHEN C.[ZZW_ST] = '1' THEN SUM(B.[ZA4_PRCESP] * B.[ZA4_QTDESP] + B.[ZA4_VIPIES] + B.[ZA4_ICRETE]) " + CRLF
    cQuery += " ELSE SUM(B.[ZA4_PRCESP] * B.[ZA4_QTDESP] + B.[ZA4_VIPIES]) " + CRLF
    cQuery += " END AS [G], " + CRLF
    cQuery += " C.[ZZW_OBS] " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZA3") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("ZA4") + " B " + CRLF
    cQuery += " ON A.[ZA3_NUM] = B.[ZA4_NUM] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("ZZW") + " C " + CRLF
    cQuery += " ON A.[ZA3_NUM] = C.[ZZW_NUM] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " D " + CRLF
    cQuery += " ON C.[ZZW_VEND] = D.[A3_COD] " + CRLF
    cQuery += " WHERE A.[ZA3_NUM] = '"+nProtoc+"' " + CRLF
    cQuery += " GROUP BY A.[ZA3_NUM], " + CRLF
    cQuery += " C.[ZZW_MOTIVO], " + CRLF
    cQuery += " A.[ZA3_CGCESP], " + CRLF
	cQuery += " A.[ZA3_NOMEES], " + CRLF
	cQuery += " A.[ZA3_ENDESP], " + CRLF
	cQuery += " A.[ZA3_MUNESP], " + CRLF
	cQuery += " A.[ZA3_ESTESP], " + CRLF
	cQuery += " A.[ZA3_INSCES], " + CRLF
    cQuery += " A.[ZA3_DTEMIS], " + CRLF
	cQuery += " B.[ZA4_DOCESP], " + CRLF
    cQuery += " C.[ZZW_VEND], " + CRLF
    cQuery += " D.[A3_EMAIL], " + CRLF
    cQuery += " D.[A3_NOME], " + CRLF
    cQuery += " C.[ZZW_OBS], " + CRLF
    cQuery += " C.[ZZW_ST] "

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

    oPrinter := FWMSPRINTER():NEW("protocolo_"+ALLTRIM((cAlias)->ZA3_NUM)+".pdf",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,.F.)
    oFont    := TFONT():NEW("Arial",,9,.T.)
    
    cDirFile  := "C:\Protocolo\protocolo_"+ALLTRIM((cAlias)->ZA3_NUM)+".pdf"
    cFile     := "protocolo_"+ALLTRIM((cAlias)->ZA3_NUM)+".pdf"
    cAssunto  := "Protocolo de Devolução N° "+ALLTRIM((cAlias)->ZA3_NUM)+""
    cCorpo    := ""
    cCorpo    += " <html> " + CRLF
    cCorpo    += " <head> " + CRLF
    cCorpo    += " <title> PROTOCOLO </title> " + CRLF
    cCorpo    += " </head> " + CRLF
    cCorpo    += " <body> " + CRLF
    cCorpo    += " <left> Protocolo: " +ALLTRIM((cAlias)->ZA3_NUM)+ " </left> " + CRLF
    cCorpo    += " <br><hr>"
    cCorpo    += " <left> Cliente: " +ALLTRIM((cAlias)->ZA3_CGCESP)+ " - "+ALLTRIM((cAlias)->ZA3_NOMEES)+" </left> " + CRLF
    cCorpo    += " <br><hr>"
    cCorpo    += " <left> Motivo da Devolução: " +ALLTRIM((cAlias)->ZZW_MOTIVO)+ " </left> " + CRLF
    cCorpo    += " <br><hr>"
    cCorpo    += " <left> Itens Envolvidos: </left> " + CRLF
    cCorpo    += " <br> " + CRLF

    cEmailRep := ALLTRIM((cAlias)->A3_EMAIL)

    FWDIRREMOVE("C:\Protocolo",.T.,.T.)
    FWDIRREMOVE("\protocolo\",.T.,.T.)
    
    WHILE (cAlias)->(!EOF())
        IF nST == "2" .AND. (cAlias)->ZA3_ESTESP <> "SP"
            nBaseST := 0
            nVlST   := 0
        ELSE 
            nBaseST := (cAlias)->C 
            nVlST   := (cAlias)->D
        ENDIF

        FWMAKEDIR("C:\Protocolo") 

        oPrinter:STARTPAGE()
        oPrinter:BOX(20,5,70,100,"-5")
        oPrinter:SAYBITMAP(28,9,"tmp\logo_novo.png",90,28)
        oPrinter:BOX(20,100,70,500,"-5")
        oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLUÇÃO",oFont)
        oPrinter:BOX(20,500,70,590,"-5")
        oPrinter:SAY(35,505,"PROTOCOLO",oFont)
        oPrinter:SAY(50,505,(cAlias)->ZA3_NUM,oFont)
        oPrinter:SAY(65,505,(cAlias)->EMISSAO,oFont)
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
        oPrinter:SAY(240,10,"CNPJ/CPF: 59.114.777/0001-20 ",oFont)
        oPrinter:SAY(250,10,"NOME/RAZÃO SOCIAL: ALUMBRA PRODUTOS ELÉTRICOS ELETRÔNICOS LTDA ",oFont)
        oPrinter:SAY(260,10,"ENDEREÇO: RUA GUIMARÃES ROSA, 450 JD. CONTINENTAL - CEP: 09851-380 - SÃO BERNARDO DO CAMPO - SP TEL: (11) 4393-9300",oFont)
        oPrinter:SAY(270,10,"INSCRIÇÃO ESTADUAL: 635.023.191.116",oFont)
        oPrinter:SAY(300,10,"4 - Dados do Produto",oFont)
        oPrinter:BOX(310,5,320,590,"-5")
        oPrinter:SAY(318,10,"ITEM",oFont)
        oPrinter:SAY(318,40,"DESCRIÇÃO DO PRODUTO",oFont)
        oPrinter:SAY(318,175,"CL FISCAL",oFont)
        oPrinter:SAY(318,215,"CFOP",oFont)
        oPrinter:SAY(318,240,"UM",oFont)
        oPrinter:SAY(318,255,"QTDE",oFont)
        oPrinter:SAY(318,280,"VL UNIT",oFont)
        oPrinter:SAY(318,315,"VL TOTAL",oFont)
        oPrinter:SAY(318,355,"BASE ICMS",oFont)
        oPrinter:SAY(318,400,"VL ICMS",oFont)
        oPrinter:SAY(318,435,"VL IPI",oFont)
        oPrinter:SAY(318,460,"% ICMS",oFont)
        oPrinter:SAY(318,490,"% IPI",oFont)
        oPrinter:SAY(318,510,"BASE ST",oFont)
        oPrinter:SAY(318,546,"VL ST",oFont)
        oPrinter:SAY(318,572,"MVA",oFont)

        cQuery1 := " SELECT " + CRLF
        cQuery1 += " B.[ZA4_PRODES], " + CRLF
        cQuery1 += " SUBSTRING(B.[ZA4_DESCES],1,31) AS [ZA4_DESCES], " + CRLF
        cQuery1 += " B.[ZA4_CLFIES], " + CRLF
        cQuery1 += " B.[ZA4_CFOPES], " + CRLF
        cQuery1 += " B.[ZA4_UMESPE], " + CRLF
        cQuery1 += " B.[ZA4_QTDESP], " + CRLF
        cQuery1 += " B.[ZA4_PRCESP], " + CRLF
        cQuery1 += " B.[ZA4_TLESPE], " + CRLF
        cQuery1 += " B.[ZA4_BICMES], " + CRLF
        cQuery1 += " B.[ZA4_VICMES], " + CRLF
        cQuery1 += " B.[ZA4_VIPIES], " + CRLF
        cQuery1 += " B.[ZA4_PICMES], " + CRLF
	    cQuery1 += " B.[ZA4_IPIESP], " + CRLF
        cQuery1 += " A.[ZA3_ESTESP], " + CRLF
        cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[ZA3_ESTESP] = 'SP' THEN B.[ZA4_BRICES] " + CRLF
        cQuery1 += " WHEN E.[ZZW_ST] = '2' THEN '0' " + CRLF
	    cQuery1 += " ELSE B.[ZA4_BRICES] " + CRLF
        cQuery1 += " END AS [ZA4_BRICES],  " + CRLF
	    cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[ZA3_ESTESP] = 'SP' THEN B.[ZA4_ICRETE] " + CRLF
        cQuery1 += " WHEN E.[ZZW_ST] = '2' THEN '0' " + CRLF
        cQuery1 += " ELSE B.[ZA4_ICRETE] " + CRLF
        cQuery1 += " END AS [ZA4_ICRETE],  " + CRLF
	    cQuery1 += " B.[ZA4_MARESP], " + CRLF
        cQuery1 += " B.[ZA4_DOCESP], " + CRLF
        cQuery1 += " B.[ZA4_EMIESP] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("ZA3") + " A " + CRLF  
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA4") + " B " + CRLF 
        cQuery1 += " ON A.[ZA3_NUM] = B.[ZA4_NUM] " + CRLF 
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery1 += " ON B.[ZA4_DOCESP] = C.[D2_DOC] AND B.[ZA4_SERESP] = C.[D2_SERIE] AND B.[ZA4_PRODES] = C.[D2_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA2") + " D " + CRLF
        cQuery1 += " ON C.[D2_TES] = D.[ZA2_TESSAI] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZZW") + " E " + CRLF
        cQuery1 += " ON A.[ZA3_NUM] = E.[ZZW_NUM] " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZA3_NUM] = '"+nProtoc+"' "

        cQuery1 := CHANGEQUERY(cQuery1)
        cAlias1 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAlias1,.F.,.T.)
        
        nPag2 := 20
        nPag3 := 18
        nHPag := 0
        WHILE (cAlias1)->(!Eof())
            cCorpo += " <left> Item: " +ALLTRIM((cAlias1)->ZA4_PRODES)+ " - "+ALLTRIM((cAlias1)->ZA4_DESCES)+" - Quantidade: "+STR((cAlias1)->ZA4_QTDESP,6)+"</left> " + CRLF
            cCorpo += " <br> "
            IF (cAlias)->ZA4_DOCESP == (cAlias1)->ZA4_DOCESP
                IF nVert1 >= 830
                   oPrinter:STARTPAGE()
                   nVert1 := nPag2 += 10
                   nVert  := nPag3 += 10
                   nHori  := nHPag += 20
                ENDIF   
                oPrinter:BOX(nVert1,5,nHori,590,"-5")
                oPrinter:SAY(nVert,10,(cAlias1)->ZA4_PRODES,oFont)
                oPrinter:SAY(nVert,40,(cAlias1)->ZA4_DESCES,oFont)
                oPrinter:SAY(nVert,175,(cAlias1)->ZA4_CLFIES,oFont)
                oPrinter:SAY(nVert,215,(cAlias1)->ZA4_CFOPES,oFont)
                oPrinter:SAY(nVert,240,(cAlias1)->ZA4_UMESPE,oFont)
                oPrinter:SAY(nVert,252,STR((cAlias1)->ZA4_QTDESP,6),oFont)
                oPrinter:SAY(nVert,266,TRANSFORM((cAlias1)->ZA4_PRCESP,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,305,TRANSFORM((cAlias1)->ZA4_TLESPE,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,348,TRANSFORM((cAlias1)->ZA4_BICMES,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,389,TRANSFORM((cAlias1)->ZA4_VICMES,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,419,TRANSFORM((cAlias1)->ZA4_VIPIES,"@E 999,999,999.99"),oFont) 
                oPrinter:SAY(nVert,447,TRANSFORM((cAlias1)->ZA4_PICMES,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,472,TRANSFORM((cAlias1)->ZA4_IPIESP,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,499,TRANSFORM((cAlias1)->ZA4_BRICES,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,529,TRANSFORM((cAlias1)->ZA4_ICRETE,"@E 999,999,999.99"),oFont)
                oPrinter:SAY(nVert,552,TRANSFORM((cAlias1)->ZA4_MARESP,"@E 999,999,999.99"),oFont)
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
        oPrinter:SAY(nVert3,10,"BASE CÁLCULO ICMS")
        oPrinter:SAY(nVert4,20,TRANSFORM((cAlias)->A,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,110,"TOTAL ICMS")
        oPrinter:SAY(nVert4,105,TRANSFORM((cAlias)->B,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,180,"BASE CÁLCULO ICMS ST")
        oPrinter:SAY(nVert4,192,TRANSFORM(nBaseST,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,290,"TOTAL ICMS ST")
        oPrinter:SAY(nVert4,292,TRANSFORM(nVlST,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,370,"TOTAL DOS PRODUTOS")
        oPrinter:SAY(nVert4,387,TRANSFORM((cAlias)->E,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,470,"TOTAL IPI")
        oPrinter:SAY(nVert4,461,TRANSFORM((cAlias)->F,"@E 999,999,999.99"),oFont)
        oPrinter:SAY(nVert3,520,"TOTAL DA NOTA")
        oPrinter:SAY(nVert4,522,TRANSFORM((cAlias)->G,"@E 999,999,999.99"),oFont)
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
        oPrinter:SAY(nVert12,50,"NF-E")
        oPrinter:SAY(nVert12,100,"SEQUÊNCIA")
        oPrinter:SAY(nVert12,160,"DATA DE EMISSÃO")
        oPrinter:SAY(nVert12,250,"CHAVE NF-E")
        nVert13 := nVert12 += 10
        nHori3  := nHori2  += 0
        nVert14 := nVert13 += 0

        cQuery2 := " SELECT D.[F2_SERIE], " + CRLF
        cQuery2 += " D.[F2_DOC], " + CRLF
        cQuery2 += " C.[D2_ITEM], " + CRLF
        cQuery2 += " FORMAT(CONVERT(DATE, D.[F2_EMISSAO]), 'dd/MM/yyyy') AS [EMISSAO], " + CRLF
	    cQuery2 += " D.[F2_CHVNFE], " + CRLF
        cQuery2 += " A.[ZA3_NUM], " + CRLF
        cQuery2 += " B.[ZA4_NUM], " + CRLF
        cQuery2 += " B.[ZA4_DOCESP] " + CRLF
        cQuery2 += " FROM " + RETSQLNAME("ZA3") + " A " + CRLF  
        cQuery2 += " LEFT JOIN " + RETSQLNAME("ZA4") + " B " + CRLF 
        cQuery2 += " ON A.[ZA3_NUM] = B.[ZA4_NUM] " + CRLF 
        cQuery2 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery2 += " ON B.[ZA4_DOCESP] = C.[D2_DOC] AND B.[ZA4_SERESP] = C.[D2_SERIE] AND B.[ZA4_PRODES] = C.[D2_COD] " + CRLF
        cQuery2 += " LEFT JOIN " + RETSQLNAME("SF2") + " D " + CRLF 
        cQuery2 += " ON B.[ZA4_DOCESP] = D.[F2_DOC] AND B.[ZA4_SERESP] = D.[F2_SERIE] " + CRLF
        cQuery2 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZA3_NUM] = '"+nProtoc+"' "

        cQuery2 := CHANGEQUERY(cQuery2)
        cAlias2 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery2),cAlias2,.F.,.T.)
        
        nPag4  := 20
        nPag5  := 18
        nHPag1 := 0
            WHILE (cAlias2)->(!Eof())
                IF (cAlias)->ZA4_DOCESP == (cAlias2)->ZA4_DOCESP
                    IF nVert13 >= 830
                        oPrinter:STARTPAGE()
                        nVert13 := nPag4  += 10
                        nVert14 := nPag5  += 10
                        nHori3  := nHPag1 += 20
                    ENDIF
                    oPrinter:BOX(nVert13,5,nHori3,590,"-5")
                    oPrinter:SAY(nVert14,10,(cAlias2)->F2_SERIE)
                    oPrinter:SAY(nVert14,50,(cAlias2)->F2_DOC)
                    oPrinter:SAY(nVert14,100,(cAlias2)->D2_ITEM)
                    oPrinter:SAY(nVert14,160,(cAlias2)->EMISSAO)
                    oPrinter:SAY(nVert14,250,(cAlias2)->F2_CHVNFE)
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
        nPag2   := NIL
        nPag3   := NIL
        nHPag   := NIL
        nPag4   := NIL
        nPag5   := NIL
        nHPag1  := NIL

       (cAlias)->(DBSKIP()) 
    ENDDO
    
    cCorpo += " <br><hr>"
    cCorpo += " <left> Observação: " +ALLTRIM((cAlias)->ZZW_OBS)+ " </left> " + CRLF
    cCorpo += " </body> " + CRLF
    cCorpo += " </html> " + CRLF 

    (cAlias)->(DBCLOSEAREA())
    
    IF ZZW_STSMER == "ESP"
        FERASE(cDirFile)
        oPrinter:cPathPDF := cDirFile
        oPrinter:PRINT()

        FWMAKEDIR("\protocolo\")
        CPYT2S(cDirFile,"\protocolo\",.F.)

        oMailServ := TMAILMANAGER():NEW()
        oMailServ:SETUSETLS(.T.)
        oMailServ:INIT("",cServEmail,cLoginEmail,cPassEmail,0,587)
        oMailServ:SETSMTPTIMEOUT(60)
    
        IF oMailServ:SMTPCONNECT() != 0
            FWALERTERROR("Erro ao conectar ao servidor SMTP","ERRO !")
            RETURN .F.  
        ENDIF

        IF oMailServ:SMTPAUTH(cLoginEmail,cPassEmail) != 0
            FWALERTERROR("Erro na autenticação SMTP","ERRO !")
            RETURN .F.
        ENDIF
     
        oMessage := TMAILMESSAGE():NEW()
        oMessage:CLEAR()
        oMessage:cDate := CVALTOCHAR(DATE())
	    oMessage:cFrom := cLoginEmail

        cQuery3 := " SELECT A.[USR_EMAIL] " + CRLF
        cQuery3 += " FROM [SYS_USR] A" + CRLF
        cQuery3 += " WHERE A.[USR_ID] = '"+  __CUSERID +"'"

        cQuery3 := CHANGEQUERY(cQuery3)
        cAlias3 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery3),cAlias3,.F.,.T.)
    
        IF ALLTRIM((cAlias3)->USR_EMAIL) $ cRespEmail
            oMessage:cTo := ""+ALLTRIM(cRespEmail)+";bruno.goncalves@alumbra.com.br"  /* -- ;"+cEmailRep+""  */
        ELSE
            FWALERTWARNING("Arquivo salvo na pasta seleciona. Usuario sem permissão para enviar e-mail ao representante. Contate o responsavél.","ATENÇÃO !")
            RETURN .F.  
        ENDIF

        (cAlias3)->(DBCLOSEAREA())

        oMessage:cCc      := ALLTRIM(cEmailCC)
	    oMessage:cSubject := ALLTRIM(cAssunto)
	    oMessage:cBody 	  := ALLTRIM(cCorpo)

        ADIR("\protocolo\" + "\*.*",@aArquivos)
        nQuantidade := LEN(aArquivos)
        IF nQuantidade == 0
            FWALERTWARNING("Arquivo salvo na pasta selecionada. Para o envio de e-mail ao representante selecionar a pasta PROTOCOLO.","ATENÇÃO !")
            RETURN .F.   
        ELSE
            oMessage:AttachFile("\protocolo\"+cFile+"")   
        ENDIF    

        IF oMessage:SEND(oMailServ) != 0
            FWALERTERROR("Erro ao enviar o e-mail","ERRO !")
            RETURN .F.
        ELSE 
            oMailServ:SMTPDISCONNECT()
        ENDIF

        FWALERTSUCCESS("E-mail enviado com sucesso", "ENVIADO !")
    ELSEIF ZZW_STSMER == "APR"
        FWALERTWARNING("Protocolo já aprovado para entrada da NF.","ATENÇÃO !")
    ELSEIF ZZW_STSMER == "PRO"
        FWALERTWARNING("Protocolo Encerrado.","ATENÇÃO !")
    ELSE 
        FWALERTWARNING("É necessario gerar o espelho.","ATENÇÃO !")
    ENDIF
RETURN
