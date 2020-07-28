tableextension 70106 GenJournalTableExt extends "Gen. Journal Line"
{
    fields
    {
        field(70106; "Forma de pago"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".code;
        }
    }

    var
        myInt: Integer;
}