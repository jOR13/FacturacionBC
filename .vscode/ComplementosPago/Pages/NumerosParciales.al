page 70145 NumerosParciales
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PartialNo;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Numeros)
            {
                field(ID; ID)
                {
                    ApplicationArea = All;
                }
                field("Partial No."; "Partial No.")
                {
                    ApplicationArea = All;
                }
                field(CustLedegerEntryNo; CustLedegerEntryNo)
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
            action(PartialNO)
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    cod: Codeunit Methods;
                    DCLE: Record "Detailed Cust. Ledg. Entry";
                    p: Record PartialNo;
                    i: Integer;
                begin
                    cod.calcPartial();
                end;
            }
        }
    }

    var
        myInt: Integer;
}