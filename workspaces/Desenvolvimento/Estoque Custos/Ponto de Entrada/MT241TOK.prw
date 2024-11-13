#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TELA DE CADASTRO - DE PARA CFOP
TELA - DE PARA CFOP
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     18/09/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

User Function MT241TOK()

    LOCAL lRet   := .T.
    LOCAL aUsers := GETMV("AL_USRTM")
    LOCAL nI     := 0
    LOCAL aArea  := GETAREA()

    DBSELECTAREA("SF5")
    DBSETORDER(1)
    nTM := SF5->F5_CODIGO
    IF lRet == .T. 
        FOR nI := 1 TO LEN(aUsers)
            IF CUSERNAME $ aUsers
                IF nTM == "001"
                ELSE 
                    FWALERTWARNING("Usuario sem permissão para usar a TM: "+nTM+".", "Atenção !")
                    lRet := .F.
                ENDIF
            ENDIF    
        NEXT
    ENDIF    
    DBCLOSEAREA()
    RESTAREA(aArea)

RETURN lRet
