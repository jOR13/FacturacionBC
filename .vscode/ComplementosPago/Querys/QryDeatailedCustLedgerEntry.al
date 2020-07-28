query 70100 QryDeatailedCustLedgerEntry
{
    QueryType = Normal;
    OrderBy = ascending(PostingDate);



    elements
    {
        dataitem(MovDetallados; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableFilter = Amount = filter(< '0'), "Entry Type" = filter(= 'Application'), Unapplied = filter(= 'false');
            column(EntryNo; "Entry No.")
            {
            }
            column(CustLedgerEntryNo; "Cust. Ledger Entry No.")
            {

            }
            column(PartialNo; PartialNo)
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(Formadepago; "Forma de pago")
            {
            }

            column(CurrencyCode; "Currency Code")
            {
            }

            column(Amount; Amount)
            {

            }
            column(AmountLCY; "Amount (LCY)")
            {

            }


            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }


            column(Unapplied; Unapplied)
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