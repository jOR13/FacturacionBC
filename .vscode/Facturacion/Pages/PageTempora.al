page 50698 PageTemporal
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = temporal;
    Editable = true;
    Permissions = tabledata 50525 = rimd;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field(DocNo; DocNo)
                {
                    ApplicationArea = All;
                }
                field(getRec; getRec)
                {
                    ApplicationArea = All;
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