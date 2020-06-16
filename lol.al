page 50786 loool
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Cr.Memo Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(UUIDNCHG; UUIDNCHG)
                {
                    ApplicationArea = All;
                }
                field(UUIDRelacionadoNC; UUIDRelacionadoNC)
                {
                    ApplicationArea = all;
                    Lookup = true;
                    TableRelation = "Sales Invoice Header".UUIDHG where("No." = filter(= '118952'));
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}