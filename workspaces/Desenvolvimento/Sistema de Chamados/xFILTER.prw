#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

User function xFILTERDOC()

    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs,{1,"CNPJ",SPACE(TAMSX3("A2_CGC")[1]),,,"SA2",,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.) 
        ALERT(aResps[1])
    ENDIF
    
Return 

