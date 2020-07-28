pageextension 70105 pageSalesLineExt extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("No. identificacion"; "No. identificacion")
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