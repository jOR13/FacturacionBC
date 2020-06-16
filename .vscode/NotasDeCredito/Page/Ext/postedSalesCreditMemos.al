pageextension 50845 PostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        modify("No.")
        {
            Style = Favorable;
            StyleExpr = color;
        }


        addafter("Location Code")
        {
            field(UUID; UUIDNCHG)
            {
                ApplicationArea = all;

                Style = Favorable;
                StyleExpr = color;
            }

            field(UUIDRelacionadoNC; UUIDRelacionadoNC)
            {
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if UUIDNCHG <> '' then begin
            color := true;
        end else begin
            color := false;
        end;
    end;



    var
        color: Boolean;
}