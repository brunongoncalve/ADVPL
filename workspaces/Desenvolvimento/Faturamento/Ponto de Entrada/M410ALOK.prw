#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} LOG DE ALTERAÇÃO PEDIDO DE VENDA
LOG PEDIDO DE VENDA
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

User Function M410ALOK()
 
Local lRet := .T.
 
If !Empty(SC5->C5_NOTA)
    If ALTERA   //Alteração
        MsgAlert("ALTERAÇÂO - Pedido já faturado.","ATENÇÃO")
    ElseIf !INCLUI .And. !ALTERA    //Exclusão
        MsgAlert("EXCLUSÃO - Pedido já faturado.","ATENÇÃO")
    ElseIf INCLUI .And. IsInCallStack("A410COPIA")  //Cópia
        MsgAlert("CÓPIA - Pedido já faturado.","ATENÇÃO")
    EndIf
    lRet := .F.
EndIf
 
Return lRet
