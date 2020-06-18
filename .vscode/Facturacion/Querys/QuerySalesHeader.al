query 50512 QrySIH
{
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            //DataItemLink = "No." = totalTraslados.Folio;

            DataItemTableFilter = UUIDHG = filter(= '');
            column(Folio; "No.") { }
            column(Serie; "Order No.") { }
            column(Fecha; "Posting Date") { }
            column(CondicionesDePago; "Due Date") { }
            column(Subtotal; Amount) { }
            column(Moneda; "Currency Code") { }
            column(TipoCambio; "Currency Factor") { }
            column(Total; "Amount Including VAT") { }
            column(Nombre; "Sell-to Customer Name") { }
            column(RFC; "VAT Registration No.") { }
            column(UsoCFDI; "CFDI Purpose") { }
            column(TipoRelacion; "CFDI Relation") { }
            column(UUIDRelation; "UUID Relation HG") { }
            column(UUID; UUIDHG) { }
            column(BOL; BOL)
            {
            }
            column(Pedimento; Pedimento)
            {
            }
            column(PeriodoFact; PeriodoFact)
            {
            }
            column(ProductoTrasnportado; ProductoTrasnportado)
            {
            }
            column(Tanque; Tanque)
            {
            }

            column(aeropuerto; aeropuerto)
            {
            }
            column(WorkDescription; "Work Description")
            {
            }
            column(Remision; Remision)
            {
            }
            column(OrigenDestino; OrigenDestino)
            {
            }
            column(NoTanque; NoTanque)
            {
            }
            column(FechaDeEntrega; FechaDeEntrega)
            {
            }

            dataitem(Payment_Method; "Payment Method")
            {
                // SqlJoinType = InnerJoin;
                DataItemLink = Code = Sales_Invoice_Header."Payment Method Code";
                column(FormaPago; "SAT Method of Payment") { }
                dataitem(Payment_Terms1; "Payment Terms")
                {
                    DataItemLink = Code = Sales_Invoice_Header."Payment Terms Code";
                    //SqlJoinType = InnerJoin;
                    column(MetodoPago; "SAT Payment Term") { }
                }
            }

        }
    }
    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin
    end;
}