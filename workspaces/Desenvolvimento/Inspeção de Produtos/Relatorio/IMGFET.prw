#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO FET DE PRODUTO
RELATORIO - EFAZ SALDO A CLASSIFICAR
@author    FET DE PRODUTO
@since     02/07/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION IMGFET()

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "Produto De", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100, .F.})
    AADD(aPergs, {1, "Produto Ate", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100, .F.})

    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
        ALERT("OLA MUNDO !!!")
    ENDIF    

RETURN
