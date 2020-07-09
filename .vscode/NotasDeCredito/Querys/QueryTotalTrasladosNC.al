query 50533 QueryTotalTrasladosNC
{
    QueryType = Normal;

    elements
    {
        dataitem(totalTrasladosNC; totalTrasladosNC)
        {
            column(Folio; Folio)
            {
            }
            column(TotalImpuestosTrasladados; TotalImpuestosTrasladados)
            {
                Method = Sum;

            }
            column(Importe; Importe)
            {
                Method = Sum;
            }
            column(Impuesto; Impuesto)
            {

            }
            column(TasaOCuota; TasaOCuota)
            {
            }
            column(TipoFactor; TipoFactor)
            {
            }
            column(Base; Base)
            {
                Method = Sum;
            }

        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}