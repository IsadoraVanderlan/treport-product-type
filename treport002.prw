//INCLUDES
#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================================
*Programa....: RELAT05
*Descricao...: Relatorio Produto por Tipo.
=================================================================================================
*/

//DEFINES
#DEFINE ENTER CHR(13)+CHR(10)

//FUNCAO PRICIPAL 
User Function RELAT05()

Private cPerg      := "RELAT05"
Private cNextAlias := GetNextAlias()

ValidPerg(cPerg)

If Pergunte(cPerg,.T.) //Vai inicializar as variaveis publicas de perguntas: mv_ch1
    oReport := ReportDef()
    oReport:PrintDialog()
EndIf

Return

//SECAO DE APRESENTACAO DE DADOS 
Static Function ReportDef()

//TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)
oReport := TReport():New(cPerg,"Relatorio Produto por Tipo",cPerg,{|oReport| ReportPrint(oReport)},"Impresscao de Relatorio Produto por Tipo")
oReport:SetLandscape(.T.) //Propriedade que denife a orientação da pagina como paisagem 
oReport:HideParamPage()   //Propriedade não apresenta a pagina com os parametros selecionados no relatorio

//TRSection():New(<aParent>,<cTitle>,<uTable>,<dOrder>)
oSection := TRSection():New(oReport,OEmToAnsi("Relatorio Produto por Tipo"),{"SA1"}) //Retorna o objeto da classe TReport que a classe TRSection pertence

//TRCell():New( <oParent> , <cName> , <cAlias> , <cTitle> , <cPicture> , <nSize> , <lPixel> , <bBlock> , <cAlign> , <lLineBreak> , <cHeaderAlign> , <lCellBreak> , <nColSpace> , <lAutoSize> , <nClrBack> , <nClrFore> , <lBold> )
TRCell():New(oSection,"B1_COD",      cNextAlias,"Codigo",      /*cPicture*/ , /*nSize*/ , /*lPixel*/ , /*{||}*/) 
TRCell():New(oSection,"B1_DESC",     cNextAlias,"Descricao",        /*cPicture*/ , /*nSize*/ , /*lPixel*/ , /*{||}*/) 
TRCell():New(oSection,"B1_TIPO",     cNextAlias,"Tipo",        /*cPicture*/ , /*nSize*/ , /*lPixel*/ , /*{||}*/) 

Return oReport

//FUNCAO DE CONSULTA 
Static Function ReportPrint(oReport)

Local oSection := oReport:Section(1)
Local cQuery   := ""
Local nCount   := 0

cQuery += "SELECT " + ENTER
cQuery += "B1_COD, " + ENTER
cQuery += "B1_DESC, " + ENTER
cQuery += "B1_TIPO " + ENTER
cQuery += "FROM SB1990 WHERE D_E_L_E_T_ = '' " + ENTER
If !EMPTY(MV_PAR01)
    cQuery += "AND B1_TIPO = '" + MV_PAR01 + "' " + ENTER
EndIf    
cQuery += "ORDER BY B1_COD"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias)  

Count to nCount
(cNextAlias)->(DbGoTop())
oReport:SetMEter(nCount)
oSection:Init()

While !(cNextAlias)->(Eof())
    oReport:IncMeter()
    oSection:Printline()
    If oReport:Cancel()
        Exit
    EndIf

    (cNextAlias)->(DbSkip())
EndDo

Return

//FUNCAO DE PERGUNTAS
Static Function ValidPerg(cPerg)

Local aAlias := GetArea() 
Local aRegs  := {}
Local i,J

cPerg := PADR(cPerg,Len(SX1->X1_GRUPO)," ") // variavel para preencher + tamanho + preencher o resto com espa�o caso o tamalho da variavel seja menos que o valor do campo

AADD(aRegs,{cPerg,"01","Tipo","","","mv_ch1","C",2,0,0,"G",MV_PAR01,"","","","","","","","","","","","","","","","","","","","","","","","","","02","","","","",""})

DBSelectArea("SX1") //Seleciona a tabela 
SX1->(DBSetOrder(1)) //Posiciona no indice 1
For i := 1 to Len(aRegs) //vai de 1 até o numero que tem de arryi 
    If !DbSeek(cPerg+aRegs[i,2]) //Senão achar a função da pergunta e a quantidade de array e a posição 2 do array
        RecLock("SX1",.T.) //Ele vai incerir um registro na tabela, se fosse .F. ele alteraria 
            For j:= 1 to FCount()
                FieldPut(j,aRegs[i,j])
            Next 
        MsUnLock()
    EndIf
Next
RestArea(aAlias)

Return












