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

User Function M410ALOK()
 
Local lRet := .T.
 
If !Empty(SC5->C5_NOTA)
    If ALTERA   //Altera��o
        MsgAlert("ALTERA��O - Pedido j� faturado.","ATEN��O")
    ElseIf !INCLUI .And. !ALTERA    //Exclus�o
        MsgAlert("EXCLUS�O - Pedido j� faturado.","ATEN��O")
    ElseIf INCLUI .And. IsInCallStack("A410COPIA")  //C�pia
        MsgAlert("C�PIA - Pedido j� faturado.","ATEN��O")
    EndIf
    lRet := .F.
EndIf
 
Return lRet
