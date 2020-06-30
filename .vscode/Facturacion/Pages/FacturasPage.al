page 50876 FacturasPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = facturas_Timbradas;
    Editable = true;
    Permissions = TableData 50523 = rimd;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(CantidadLetra; CantidadLetra)
                {
                    ApplicationArea = All;
                }
                field(CertificadoCadena; CertificadoCadena)
                {
                    ApplicationArea = All;
                }
                field(CertificadoCadenaPart2; CertificadoCadenaPart2)
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }
                field(DescuentoTotal; DescuentoTotal)
                {
                    ApplicationArea = All;
                }
                field(Fecha; Fecha)
                {
                    ApplicationArea = All;
                }
                field(FechaTimbrado; FechaTimbrado)
                {
                    ApplicationArea = All;
                }
                field(Folio; Folio)
                {
                    ApplicationArea = All;
                }
                field(FormaDePago; FormaDePago)
                {
                    ApplicationArea = All;
                }
                field(IVA; IVA)
                {
                    ApplicationArea = All;
                }
                field("Lugar de expedición"; "Lugar de expedición")
                {
                    ApplicationArea = All;
                }
                field("Metodo de pago"; "Metodo de pago")
                {
                    ApplicationArea = All;
                }
                field(Moneda; Moneda)
                {
                    ApplicationArea = All;
                }
                field(NoCertificado; NoCertificado)
                {
                    ApplicationArea = All;
                }
                field(NoCertificadoSAT; NoCertificadoSAT)
                {
                    ApplicationArea = All;
                }
                field(Nombre; Nombre)
                {
                    ApplicationArea = All;
                }
                field(NombreReceptor; NombreReceptor)
                {
                    ApplicationArea = All;
                }
                field("QR String"; "QR String")
                {
                    ApplicationArea = All;
                }
                field(RFC; RFC)
                {
                    ApplicationArea = All;
                }
                field("RFC provedor"; "RFC provedor")
                {
                    ApplicationArea = All;
                }
                field("Regimen Fiscal"; "Regimen Fiscal")
                {
                    ApplicationArea = All;
                }
                field(RetencionesTotales; RetencionesTotales)
                {
                    ApplicationArea = All;
                }
                field(RfcReceptor; RfcReceptor)
                {
                    ApplicationArea = All;
                }
                field(SelloDigitalCFD; SelloDigitalCFD)
                {
                    ApplicationArea = All;
                }
                field(SelloSAT; SelloSAT)
                {
                    ApplicationArea = All;
                }
                field(Subtotal; Subtotal)
                {
                    ApplicationArea = All;
                }
                field("Tipo relacion"; "Tipo relacion")
                {
                    ApplicationArea = All;
                }
                field(TipoCambio; TipoCambio)
                {
                    ApplicationArea = All;
                }
                field(Total; Total)
                {
                    ApplicationArea = All;
                }
                field(TotalText; TotalText)
                {
                    ApplicationArea = All;
                }
                field(UUID; UUID)
                {
                    ApplicationArea = All;
                }
                field("UUID Relacionado"; "UUID Relacionado")
                {
                    ApplicationArea = All;
                }
                field(UsoCFDI; UsoCFDI)
                {
                    ApplicationArea = All;
                }
                field(Version; Version)
                {
                    ApplicationArea = All;
                }
                field(id; id)
                {
                    ApplicationArea = All;
                }
                field(tipoDeComprobante; tipoDeComprobante)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Borrar facturas")
            {
                ApplicationArea = All;

                Image = Delegate;
                trigger OnAction()
                var
                    ft: Record facturas_Timbradas;

                begin
                    ft.DeleteAll();
                end;
            }

            action("Borrar nc")
            {
                ApplicationArea = All;
                Image = Delegate;
                trigger OnAction()
                var
                    ft: Record NCTimbradas;
                    ftc: Record ConceptosNC;

                begin
                    ft.DeleteAll();
                end;
            }


        }

    }
    var
        myInt: Integer;
}