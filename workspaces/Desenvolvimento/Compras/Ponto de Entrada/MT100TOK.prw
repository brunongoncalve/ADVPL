#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA - INCLUSÃO DO DOCUIMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     23/01/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION MT100TOK()

    LOCAL lRet := .T. // Variável de retorno, .T. para executar a inclusão, .F. para não executar

    ALERT(M->(SF1->F1_FORNECE))

RETURN lRet
