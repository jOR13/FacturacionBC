pageextension 70107 DetailedCustLedgerEntry extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addfirst(Control1)
        {
            field(PartialNo; PartialNo)
            {
                ApplicationArea = all;
            }
        }

        addafter("Currency Code")
        {
            field("Forma de pago"; "Forma de pago")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    var
        myInt: Integer;
}