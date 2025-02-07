#INCLUDE "TOTVS.ch"
#INCLUDE "FWMBROWSE.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} FUNÇÃO - INSER DO PROTOCOLO NA TABELA ZA3 E ZA4
INSER DO PROTOCOLO NA TABELA ZA3 E ZA4
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     11/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xINSERI()
    
    LOCAL aArea         := GETAREA()
    LOCAL cQuery        := ""
    LOCAL cQuery1       := ""
    LOCAL aProtoc       := ZZW->ZZW_NUM
    PRIVATE lMsErroAuto := .F.

    cQuery := " SELECT A.[ZZW_NUM]," + CRLF
    cQuery += " A.[ZZW_DTINI], " + CRLF
    cQuery += " B.[A1_CGC], " + CRLF
	cQuery += " B.[A1_NOME], " + CRLF
	cQuery += " B.[A1_END], " + CRLF
	cQuery += " B.[A1_EST], " + CRLF
	cQuery += " B.[A1_MUN], " + CRLF
	cQuery += " B.[A1_INSCR] " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF 
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF 
    cQuery += " ON A.[ZZW_CLI] = B.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+aProtoc+"'" + CRLF

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)
    
    BEGIN TRANSACTION
        DBSELECTAREA("ZA3")
        DBSETORDER(1)
        DBAPPEND() 
            ZA3->ZA3_FILIAL := "010101"
            ZA3->ZA3_NUM    := (cAlias)->ZZW_NUM
            ZA3->ZA3_DTEMIS := (cAlias)->ZZW_DTINI
            ZA3->ZA3_CGCESP := (cAlias)->A1_CGC
            ZA3->ZA3_NOMEES := (cAlias)->A1_NOME
            ZA3->ZA3_ENDESP := (cAlias)->A1_END
            ZA3->ZA3_MUNESP := (cAlias)->A1_MUN
            ZA3->ZA3_ESTESP := (cAlias)->A1_EST
            ZA3->ZA3_INSCES := (cAlias)->A1_INSCR
        DBCLOSEAREA()
        DBCOMMIT()
        RESTAREA(aArea)

        cQuery1 := " SELECT B.[ZZY_PROD], " + CRLF
        cQuery1 += " A.[ZZW_NUM], " + CRLF
        cQuery1 += " B.[ZZY_NF], " + CRLF
        cQuery1 += " SUBSTRING(D.[B1_DESC],1,31) AS [B1_DESC], " + CRLF
        cQuery1 += " D.[B1_POSIPI], " + CRLF
        cQuery1 += " E.[ZA2_CFOPIM], " + CRLF
        cQuery1 += " C.[D2_UM], " + CRLF
        cQuery1 += " B.[ZZY_QTD], " + CRLF
        cQuery1 += " C.[D2_PRCVEN], " + CRLF
        cQuery1 += " C.[D2_PRCVEN] * B.[ZZY_QTD] AS [D2_TOTAL], " + CRLF
        cQuery1 += " ROUND(CAST(C.[D2_BASEICM] / C.[D2_QUANT] * B.[ZZY_QTD] AS DECIMAL(10, 2)),2) AS [D2_BASEICM], " + CRLF
        cQuery1 += " ROUND(CAST(C.[D2_BASEICM] / C.[D2_QUANT] * B.[ZZY_QTD] * (C.[D2_PICM] / 100) AS DECIMAL(10, 2)),2) AS [D2_VALICM], " + CRLF
        cQuery1 += " ROUND(CAST(B.[ZZY_QTD] * C.[D2_PRCVEN] * (C.[D2_IPI] / 100) AS DECIMAL(10, 2)),2) AS [D2_VALIPI], " + CRLF
        cQuery1 += " C.[D2_PICM], " + CRLF
	    cQuery1 += " C.[D2_IPI], " + CRLF
	    cQuery1 += " ROUND(ROUND((C.[D2_BRICMS] / C.[D2_QUANT]),2) * B.[ZZY_QTD],2) AS [D2_BRICMS], " + CRLF
	    cQuery1 += " ROUND(ROUND((C.[D2_ICMSRET] - C.[D2_VFECPST]) / C.[D2_QUANT],2) * B.[ZZY_QTD], 2) AS [D2_ICMSRET], " + CRLF
	    cQuery1 += " C.[D2_MARGEM], " + CRLF
        cQuery1 += " F.[F2_SERIE], " + CRLF
        cQuery1 += " F.[F2_DOC], " + CRLF
        cQuery1 += " B.[ZZY_SEQUEN], " + CRLF
        cQuery1 += " FORMAT(CONVERT(DATE, F.[F2_EMISSAO]), 'dd/MM/yyyy') AS [EMISSAO], " + CRLF
        cQuery1 += " F.[F2_CHVNFE] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
        cQuery1 += " ON A.[ZZW_NUM] = B.[ZZY_NUM] " + CRLF 
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery1 += " ON CONVERT(VARCHAR, CONVERT(INT, B.[ZZY_NF])) = CONVERT(VARCHAR, CONVERT(INT, C.[D2_DOC])) AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SB1") + " D " + CRLF 
        cQuery1 += " ON B.[ZZY_PROD] = D.[B1_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA2") + " E " + CRLF
        cQuery1 += " ON C.[D2_TES] = E.[ZA2_TESSAI] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SF2") + " F " + CRLF 
        cQuery1 += " ON C.[D2_DOC] = F.[F2_DOC] " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+ aProtoc +"'"

        cQuery1 := CHANGEQUERY(cQuery1)
        cAlias1 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAlias1,.F.,.T.)

        WHILE (cAlias1)->(!Eof())
            DBSELECTAREA("ZA4")
            DBSETORDER(1)
            DBAPPEND() 
                ZA4->ZA4_FILIAL := "010101"
                ZA4->ZA4_NUM    := (cAlias1)->ZZW_NUM
                ZA4->ZA4_PRODES := (cAlias1)->ZZY_PROD
                ZA4->ZA4_DESCES := (cAlias1)->B1_DESC
                ZA4->ZA4_CLFIES := (cAlias1)->B1_POSIPI
                ZA4->ZA4_CFOPES := (cAlias1)->ZA2_CFOPIM
                ZA4->ZA4_UMESPE := (cAlias1)->D2_UM
                ZA4->ZA4_QTDESP := (cAlias1)->ZZY_QTD
                ZA4->ZA4_PRCESP := (cAlias1)->D2_PRCVEN
                ZA4->ZA4_TLESPE := (cAlias1)->D2_TOTAL
                ZA4->ZA4_BICMES := (cAlias1)->D2_BASEICM
                ZA4->ZA4_VICMES := (cAlias1)->D2_VALICM
                ZA4->ZA4_VIPIES := (cAlias1)->D2_VALIPI
                ZA4->ZA4_PICMES := (cAlias1)->D2_PICM
                ZA4->ZA4_IPIESP := (cAlias1)->D2_IPI
                ZA4->ZA4_BRICES := (cAlias1)->D2_BRICMS
                ZA4->ZA4_ICRETE := (cAlias1)->D2_ICMSRET
                ZA4->ZA4_MARESP := (cAlias1)->D2_MARGEM
                ZA4->ZA4_SERESP := (cAlias1)->F2_SERIE
                ZA4->ZA4_DOCESP := (cAlias1)->F2_DOC
                ZA4->ZA4_ITEESP := (cAlias1)->ZZY_SEQUEN
                ZA4->ZA4_EMIESP := (cAlias1)->EMISSAO
                ZA4->ZA4_CHVESP := (cAlias1)->F2_CHVNFE
            DBCLOSEAREA()
            DBCOMMIT()
            RESTAREA(aArea)
      
            (cAlias1)->(DBSKIP())
        ENDDO

    IF lMsErroAuto
        MOSTRAERRO()
        DISARMTRANSACTION()
    ENDIF
    END TRANSACTION    

    (cAlias1)->(DBCLOSEAREA())
    
RETURN
