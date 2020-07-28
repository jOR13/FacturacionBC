tableextension 70105 salesInvoiceTableExt extends "Sales Line"
{
    fields
    {
        field(70105; "No. identificacion"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }
    var
        myInt: Integer;
}
