tableextension 50517 ItemChargeExt extends "Item Charge"
{
    fields
    {
        field(50621; "C. A Costo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Enabled = true;
            Editable = true;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "C. A Costo con IVA" := false;
            end;
        }

        field(50622; "C. A Costo con IVA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Enabled = true;
            Editable = true;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "C. A Costo" := false;
            end;
        }
    }

    var
        status: Boolean;
}

pageextension 50622 ItemChargePageExt extends "Item Charges"
{
    layout
    {
        addfirst(Control1)
        {
            field("C. A Costo";
            "C. A Costo")
            {
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
                Style = Favorable;
            }

            field("C. A Costo con IVA"; "C. A Costo con IVA")
            {
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
                Style = Favorable;
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