#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA - INCLUSÃO DO DOCUIMENTO DE ENTRADA
@author    BRUNO NASCIMENTO GONÇALVES
@since     23/01/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

User Function MT103DRF()

  Local aImpRet := {}
  Local nValor  := 1
   
   AADD(aImpRet,{"IRR",nValor,"1708"})
   AADD(aImpRet,{"PIS",nValor,"1708"})
   AADD(aImpRet,{"COF",nValor,"1708"})
   AADD(aImpRet,{"CSL",nValor,"1708"})

Return aImpRet

