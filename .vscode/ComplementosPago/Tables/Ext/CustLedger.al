/*tableextension 70108 CustLedger extends "Cust. Ledger Entry"
{
    fields
    {
        field(70106; "Forma de pago"; Code[50])
        {
            DataClassification = ToBeClassified;


        }
    }

    var
        myInt: Integer;
}

pageextension 70108 CustLedger extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Forma de pago"; "Forma de pago")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}
*/



/*

tableextension 70109 GenLedger extends "G/L Entry"
{
    fields
    {
        field(70106; "Forma de pago"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}

pageextension 70109 GenLedger extends "General Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Forma de pago"; "Forma de pago")
            {
                ApplicationArea = all;
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
*/
