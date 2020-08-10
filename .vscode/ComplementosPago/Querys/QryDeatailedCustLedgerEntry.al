query 70100 QryDeatailedCustLedgerEntry
{
    QueryType = Normal;
    OrderBy = ascending(FechaPago);

    elements
    {
        dataitem(MovDetallados; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableFilter = /*IdDocumento = filter(<> ''),*/ Amount = filter(< '0'), "Entry Type" = filter(= 'Application|Initial Entry'), Unapplied = filter(= 'false')/*, "Document Type" = filter(<> 'Refund')*/;


            column(NumParcialidad;
            PartialNo)
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(CustLedgerEntryNo; "Cust. Ledger Entry No.")
            {

            }

            column(ClienteNo; "Customer No.")
            {
            }


            column(EntryType; "Entry Type")
            {

            }
            column(FechaPago; "Posting Date")
            {
            }
            // column(Formadepago; "Forma de pago")
            // {

            // }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }

            column(Moneda; "Currency Code")
            {
            }

            column(Monto; Amount)
            {

            }
            column(AmountLCY; "Amount (LCY)")
            {

            }
            column(TipoCambio; TipoCambio)
            {

            }

            column(Unapplied; Unapplied)
            {
            }
            column(IdDocumento; IdDocumento)
            {
            }
            column(ImpSaldoAnt; SaldoRestante)
            {
            }
            dataitem(Sales_Invoice_Header; "Sales Invoice Header")
            {

                DataItemLink = "No." = MovDetallados."Document No.";

                // column(UUIDHG; UUIDHG)
                // {

                // }

                // column(SaldoRestante; "Remaining Amount")
                // {

                // }




                dataitem(MetodoPagoTmp; MetodoPagoTmp)
                {
                    DataItemLink = docNo = Sales_Invoice_Header."No.";
                    column(Forma_de_pago; "Forma de pago")
                    {
                    }

                    dataitem(Customer; Customer)
                    {
                        DataItemLink = "No." = MovDetallados."Customer No.";
                        column(NombreR; Name)
                        {
                        }
                        column(RFCNoR; "RFC No.")
                        {
                        }
                    }

                }

            }

        }
    }



    var
        temporal: Decimal;

    trigger OnBeforeOpen()
    begin



    end;


}
