tableextension 70107 DetailedCustLedgerEntry extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(70107; PartialNo; Integer)
        {
            DataClassification = ToBeClassified;

        }

        // field(70106; "Forma de pago"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Payment Method".code;
        // }
    }

    var
        myInt: Integer;
}