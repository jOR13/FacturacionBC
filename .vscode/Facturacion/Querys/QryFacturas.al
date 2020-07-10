query 60513 QryFacFull
{
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {

            column(Folio; "No.") { }
            column(Serie; "Order No.") { }
            column(id_cliente; "Sell-to Customer No.") { }
            column(Nombre; "Sell-to Customer Name") { }
            column(Fecha; "Posting Date") { }
            column(CondicionesDePago; "Due Date") { }
            column(Subtotal; Amount) { }
            column(Moneda; "Currency Code") { }
            column(TipoCambio; "Currency Factor") { }
            column(Total; "Amount Including VAT") { }
            column(RFC; "VAT Registration No.") { }
            column(UsoCFDI; "CFDI Purpose") { }
            column(TipoRelacion; "CFDI Relation") { }

            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
        }
    }
    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin
    end;
}