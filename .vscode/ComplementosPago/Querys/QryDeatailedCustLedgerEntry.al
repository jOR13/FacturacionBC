query 70100 QryDeatailedCustLedgerEntry
{
    QueryType = Normal;
    OrderBy = ascending(PostingDate);


    elements
    {
        dataitem(MovDetallados; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableFilter = Amount = filter(< '0');
            column(EntryNo; "Entry No.")
            {
            }
            column(CustLedgerEntryNo; "Cust. Ledger Entry No.")
            {
                Method = Sum;
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
                Method = sum;
            }
            column(AmountLCY; "Amount (LCY)")
            {
                Method = sum;
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

            filter(Entry_Type; "Entry Type")
            {
                ColumnFilter = Entry_Type = filter(= 'Aplication');
            }

            filter(UnappliedF; Unapplied)
            {
                ColumnFilter = UnappliedF = filter(= 'false');
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}