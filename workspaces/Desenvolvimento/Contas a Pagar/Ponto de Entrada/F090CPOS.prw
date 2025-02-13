#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - FILTRO POR CNPJ / DOCUMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION F090CPOS(aCampos)

    Local aArea := GetArea()
    Local aNewCampos := {}

    // Adiciona os campos desejados na ordem específica
    aAdd(aNewCampos, {"E2_VALOR", "", "VALOR", "@!"})
    aAdd(aNewCampos, {"E2_NUM", "", "Numero Tit.", "@!"})
    aAdd(aNewCampos, {"E2_FORNECE", "", "Fornecedor", "@!"})


    // Retorna o array com os campos ordenados
    RestArea(aArea)

Return aNewCampos
