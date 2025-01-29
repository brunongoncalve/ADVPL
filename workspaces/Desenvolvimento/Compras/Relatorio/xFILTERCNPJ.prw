#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - FILTRO POR CNPJ / DOCUMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xFILTERCNPJ()

    LOCAL aPergs  := {}
    LOCAL aResps  := {}
    LOCAL cQuery  := ""

    AADD(aPergs,{1,"CNPJ DO FORNECEDOR",SPACE(TAMSX3("A2_CGC")[1]),,,"SA2CNP",,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
        cQuery := " SELECT " + CRLF
        cQuery += " A.[F1_FORNECE] " + CRLF
        cQuery += " FROM " + RETSQLNAME("SF1") + " A " + CRLF
        cQuery += " LEFT JOIN " + RETSQLNAME("SA2") + " B " + CRLF
        cQuery += " ON A.[F1_FORNECE] = B.[A2_COD] " + CRLF
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND B.[A2_CGC] = '"+aResps[1]+"'"

        cQuery := CHANGEQUERY(cQuery)
        cAlias := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

        cFil := "SF1->F1_FORNECE == '"+(cAlias)->F1_FORNECE+"'"
    ENDIF

RETURN cFil


