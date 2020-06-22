query 50531 QrySCH
{
    QueryType = Normal;

    elements
    {
        // dataitem(totalTraslados; totalTraslados)
        //{
        dataitem(Sales_Cr_Memo_Header; "Sales Cr.Memo Header")
        {
            //DataItemLink = "No." = totalTraslados.Folio;

            //DataItemTableFilter = Cancelled = filter(<> 'Yes');

            DataItemTableFilter = UUIDNCHG = filter(= '');
            column(PreAssignedNo; "Pre-Assigned No.") { }
            column(Folio; "No.") { }
            column(Fecha; "Posting Date") { }
            column(CondicionesDePago; "Due Date") { }
            column(Subtotal; Amount) { }
            column(Moneda; "Currency Code") { }
            column(TipoCambio; "Currency Factor") { }
            column(Total; "Amount Including VAT") { }
            column(Nombre; "Sell-to Customer Name") { }
            column(RFC; "VAT Registration No.") { }
            column(UsoCFDI; "CFDI Purpose") { }
            column(CFDIRelation; "CFDI Relation") { }
            column(FolioRelacionado; "Applies-to Doc. No.") { }

            column(UUIDRelacionado; UUIDRelacionadoNC)
            {

            }
            dataitem(Payment_Method; "Payment Method")
            {
                //SqlJoinType = InnerJoin;
                DataItemLink = Code = Sales_Cr_Memo_Header."Payment Method Code";
                column(MetodoPago; "SAT Method of Payment") { }
                dataitem(Payment_Terms1; "Payment Terms")
                {
                    DataItemLink = Code = Sales_Cr_Memo_Header."Payment Terms Code";
                    //SqlJoinType = InnerJoin;
                    column(FormaPago; "SAT Payment Term") { }
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