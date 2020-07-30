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
                p1, p2 : integer;
                p: Record PermisosCRE;
            begin
                l.get(rec."Location Code");
                if l.PermisoCode <> '' then begin
                    rec."No. identificacion" := l.PermisoCode;
                end;

                c.get(rec."Sell-to Customer No.");
                if c.PermisoCodeCliente <> '' then begin
                    rec."No. identificacion" := c.PermisoCodeCliente;
                end;

                if rec."No. identificacion" <> '' then begin
                    p.Get(rec."No. identificacion");
                    if p."Last no Used" = 0 then begin
                        p."Last no Used" := 1;
                    end else begin
                        p."Last no Used" += 1;
                    end;
                    p.Modify();
                    rec."No. identificacion" := p."No. Permiso" + '-' + Format(p."Last no Used");
                end else begin
                    rec."No. identificacion" := "No.";
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