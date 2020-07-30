tableextension 70105 salesInvoiceTableExt extends "Sales Line"
{
    fields
    {

        field(70105; "No. identificacion"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    var
        myInt: Integer;
}

tableextension 70127 salesInvoiceLineTableExt extends "Sales Invoice Line"
{
    fields
    {

        field(70105; "No. identificacion"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    var
        myInt: Integer;
}