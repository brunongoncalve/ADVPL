#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA - INCLUS�O DO DOCUIMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GON�ALVES
@since     23/01/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION MT100TOK()

    LOCAL lRet := .T. // Vari�vel de retorno, .T. para executar a inclus�o, .F. para n�o executar

    ALERT(M->(SF1->F1_FORNECE))

RETURN lRet
