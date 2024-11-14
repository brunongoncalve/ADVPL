#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA - INCLUSÃO DE MOVIMENTOS INTERNOS
INCLUSÃO DE MOVIMENTOS INTERNOS
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     12/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

User Function MT241TOK()

    LOCAL lRet   := .T.
    LOCAL aUsers := GETMV("AL_USRTM")
    LOCAL aArea  := GETAREA()

    DBSELECTAREA("SF5")
    DBSETORDER(1)
    nTM := SF5->F5_CODIGO
    IF lRet == .T.
        IF nTM == "001"
            IF CUSERNAME $ aUsers
                lRet := .T.
            ELSE
                FWALERTWARNING("Usuario sem permissão para usar a TM: "+nTM+".", "Atenção !")
                lRet := .F.
            ENDIF
        ELSE
            lRet := .T.    
        ENDIF
    ENDIF    
    DBCLOSEAREA()
    RESTAREA(aArea)

RETURN lRet
