#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} LOG DE ALTERA��O PEDIDO DE VENDA
PONTO DE ENTRADA - LOG PEDIDO DE VENDA
@author    BRUNO NASCIMENTO GON�ALVES
@since     06/06/2024
@version   12/superior

3 - Inclus�o
4 - Altera��o
5 - Exclus�o
6 - C�pia
7 - Devolu��o de Compras

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
