pageextension 70109 SalesOrderSubExt extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("No. identificacion"; "No. identificacion")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                l: record Location;
                c: record Customer;
            begin
                l.get(rec."Location Code");
                if l.PermisoCode <> '' then begin
                    rec."No. identificacion" := l.PermisoCode;
                end;

                l.get(rec."Sell-to Customer No.");
                if l.PermisoCode <> '' then begin
                    rec."No. identificacion" := l.PermisoCode;
                end;



            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}