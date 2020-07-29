/*pageextension 70105 pageSalesLineExt extends "Sales Order"
{
    layout
    {

        addafter("No.")
        {
            field("No. identificacion"; "No. identificacion")
            {
                ApplicationArea = All;
                //TableRelation = PermisosCRE.code;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}*/