#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} LOG DE ALTERAÇÃO PEDIDO DE VENDA
PONTO DE ENTRADA - LOG PEDIDO DE VENDA
@author    BRUNO NASCIMENTO GONÇALVES
@since     06/06/2024
@version   12/superior

3 - Inclusão
4 - Alteração
5 - Exclusão
6 - Cópia
7 - Devolução de Compras

*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION M410STTS()
 
    LOCAL _nOper := PARAMIXB[1]
    LOCAL aArea  := GETAREA()

    IF _nOper == 4
        IF CUSERNAME != "Administrador"
            DBSELECTAREA("ZZX")
            DBSETORDER(1)
            DBAPPEND() 
            ZZX->ZZX_FILIAL := "01"
            ZZX->ZZX_CAMPO := "TESTE"
            DBCOMMIT()
            RESTAREA(aArea)
        ENDIF 
    ENDIF
 
RETURN NIL
