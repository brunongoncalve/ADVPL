#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELAT01
TELA
@author    BRUNO NASCIMENTO GONÇALVES
@since     17/10/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION XMBROWSE()

    LOCAL cQuery        := "SA1"
    LOCAL cTitulo       := "TESTE"
    LOCAL cRelat        := "U_RELAT01"

    AXCADASTRO(cQuery, cTitulo, cRelat)

RETURN NIL
