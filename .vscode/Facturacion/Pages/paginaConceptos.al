page 50684 PaginaConceptos
{
    PageType = Card;
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}