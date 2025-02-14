#INCLUDE 'PROTHEUS.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - FILTRO POR CNPJ / DOCUMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

User Function F090CHOK()
    Local aTitulos := PARAMIXB // Array com os títulos selecionados

    // Ordena o array aTitulos em ordem crescente pelo valor
    Asort(aTitulos,,,{|x, y| x[3] < y[3]})

    ALERT("TESTE")

Return aTitulos
