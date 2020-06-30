page 50684 PaginaConceptos
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Conceptos;
    Editable = true;
    Permissions = TableData 50522 = rimd;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(BaseTraslado; BaseTraslado)
                {
                    ApplicationArea = All;
                }
                field(Cantidad; Cantidad)
                {
                    ApplicationArea = All;
                }
                field(ClaveProdServ; ClaveProdServ)
                {
                    ApplicationArea = All;
                }
                field(ClaveUnidad; ClaveUnidad)
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }
                field(Descuento; Descuento)
                {
                    ApplicationArea = All;
                }
                field(Folio; Folio)
                {
                    ApplicationArea = All;
                }
                field(Importe; Importe)
                {
                    ApplicationArea = All;
                }
                field(ImporteTraslado; ImporteTraslado)
                {
                    ApplicationArea = All;
                }
                field(ImpuestoTraslado; ImpuestoTraslado)
                {
                    ApplicationArea = All;
                }
                field(NoIdentificacion; NoIdentificacion)
                {
                    ApplicationArea = All;
                }
                field(TasaOCuotaTraslado; TasaOCuotaTraslado)
                {
                    ApplicationArea = All;
                }
                field(TipoFactor; TipoFactor)
                {
                    ApplicationArea = All;
                }
                field(Unidad; Unidad)
                {
                    ApplicationArea = All;
                }
                field(ValorUnitario; ValorUnitario)
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
                    ftc: Record Conceptos;

                begin
                    ftc.DeleteAll();
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
                    ftc.DeleteAll();
                    ft.DeleteAll();
                end;
            }


        }

    }

    var
        myInt: Integer;
}