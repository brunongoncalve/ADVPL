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
    //LOCAL cQuery  := ""
    //LOCAL cFOR   := ""

    AADD(aPergs,{1,"PRODUTO",SPACE(TAMSX3("A2_COD")[1]),,,"SA2",,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
        
        cFil := "SF1->F1_FORNECE == '"+aResps[1]+"'"
    ENDIF

    //cFil := "SF1->F1_FORNECE == '"+(cAlias)->F1_FORNECE+"'"
    
RETURN cFil


