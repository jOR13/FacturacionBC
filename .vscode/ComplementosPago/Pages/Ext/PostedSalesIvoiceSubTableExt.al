pageextension 70111 PostedSalesIvoiceSubTableExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("No. identificacion"; "No. identificacion")
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