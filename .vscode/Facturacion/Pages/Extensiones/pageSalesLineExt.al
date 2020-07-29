pageextension 70105 pageSalesLineExt extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("No. identificacion"; "No. identificacion")
            {
                ApplicationArea = All;
                Style = Favorable;
                DrillDownPageID = "No. Series";
                trigger OnDrillDown()
                var
                    s: Record "No. Series Line";
                    i: Integer;
                begin
                    s.Get('LP/18773/TRA/2016', '1000');
                    if s."Last No. Used" = '' then begin
                        s."Last No. Used" := '1';
                        rec."No. identificacion" := s."Series Code" + s."Last No. Used";
                    end else begin

                        Evaluate(i, s."Last No. Used");
                        i += 1;
                        rec."No. identificacion" := s."Series Code" + Format(i);
                    end;
                end;
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