#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - FILTRO POR PRODUTO / DOCUMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xFILTERPRO()

    LOCAL aPergs  := {}
    LOCAL aResps  := {}
    LOCAL cQuery  := ""

    AADD(aPergs,{1,"COD. PRODUTO",SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
        cQuery := " SELECT " + CRLF
        cQuery += " A.[F1_FORNECE] " + CRLF
        cQuery += " FROM " + RETSQLNAME("SF1") + " A " + CRLF
        cQuery += " LEFT JOIN " + RETSQLNAME("SD1") + " B " + CRLF
        cQuery += " ON A.[F1_DOC] = B.[D1_DOC] " + CRLF
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND B.[D1_COD] = '"+aResps[1]+"'"

        cQuery := CHANGEQUERY(cQuery)
        cAlias := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

        cFil := "SF1->F1_FORNECE == '"+(cAlias)->F1_FORNECE+"'"
    ENDIF

RETURN cFil
