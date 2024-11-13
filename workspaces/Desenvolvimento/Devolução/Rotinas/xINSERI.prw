#INCLUDE "TOTVS.ch"
#INCLUDE "FWMBROWSE.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} FUNÇÃO - INSER DO PROTOCOLO NA TABELA ZA3 E ZA4
INSER DO PROTOCOLO NA TABELA ZA3 E ZA4
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     11/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xINSERI()
    
    LOCAL aArea  := GETAREA()

    DBSELECTAREA("ZZW")
    DBSETORDER(1)
    DBAPPEND() 
    ZZW->ZZX_FILIAL := "010101"
    ZZX->ZZW_NUM    := "60000050"
    DBCLOSEAREA()
    DBCOMMIT()
    RESTAREA(aArea)

RETURN
