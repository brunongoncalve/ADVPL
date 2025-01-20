#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xFILTERDOC()

    LOCAL aPergs  := {}
    LOCAL aResps  := {}
    LOCAL cQuery  := ""

    AADD(aPergs,{1,"PRODUTO",SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100,.F.})

    cQuery := " SELECT "
    cQuery += " A.[F1_FORNECE] "
    cQuery += " FROM " + RETSQLNAME("SF1") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SD1") + " B " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[D1_COD] = '"+ aResps[1] +"'"

    cQuery    := CHANGEQUERY(cQuery)
    cAliasFOR := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasFOR,.F.,.T.)
    
    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.) 
        ALERT((cAliasFOR)->F1_FORNECE)
    ENDIF
    
RETURN (cAliasFOR)->F1_FORNECE

