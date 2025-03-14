#INCLUDE 'PROTHEUS.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA - VERIFICA OS IMPOSTOS IRR,PIS,COFIS,CSL OBRIGANDO A GERAÇÃO DA DIRF
@author    BRUNO NASCIMENTO GONÇALVES
@since     23/01/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION MT103DRF()

    LOCAL aImpRet := {}
    LOCAL nValor  := 1

    AADD(aImpRet,{"IRR",nValor,"1708"})
    AADD(aImpRet,{"PIS",nValor,"5952"})
    AADD(aImpRet,{"COF",nValor,"5952"})
    AADD(aImpRet,{"CSL",nValor,"5952"})

RETURN aImpRet
