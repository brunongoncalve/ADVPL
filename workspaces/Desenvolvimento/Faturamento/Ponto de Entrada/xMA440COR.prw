#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} LEGENDA LIBERAÇÃO DE PEDIDOS
TELA
@author    BRUNO NASCIMENTO GONÇALVES
@since     23/11/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION MA440COR()

    LOCAL aCores := {}

    AADD(aCores, {"C5_XSTEX == 'AX'", "BR_VERDE", "Teste 01"})
    AADD(aCores, {"C5_XSTEX == 'AL'", "BR_AMARELO", "Teste 02"}) 

RETURN aCores

USER FUNCTION MA410LEG()

    LOCAL aLegenda := PARAMIXB
    aLegenda := {}

    AADD(aLegenda,{"BR_VERDE" ,"Aguardando Impressao"})
    AADD(aLegenda,{"BR_AMARELO" ,"Pedido Impresso"})

RETURN aLegenda
