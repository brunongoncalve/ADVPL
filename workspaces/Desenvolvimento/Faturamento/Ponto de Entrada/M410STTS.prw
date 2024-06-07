#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} LOG DE ALTERA��O PEDIDO DE VENDA
LOG PEDIDO DE VENDA
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
 
    LOCAL _nOper  := PARAMIXB[1]
    LOCAL aCampos := SC5->(DBSTRUCT())
    LOCAL nI      := 0

    IF _nOper == 4
        IF CUSERNAME != "Administrador"
            FOR nI := 1 TO LEN(aCampos)
                cCampo := aCampos[nI][1]
                IF &("SF4->"+cCampo) != &("M->"+cCampo)
                    ALERT("O CAMPO "cCampo" SERA ALTERADO") 
                ENDIF
            NEXT
        ENDIF 
    ENDIF
 
RETURN NIL
