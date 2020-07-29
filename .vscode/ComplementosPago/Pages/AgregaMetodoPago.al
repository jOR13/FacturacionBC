page 70109 AgregaMetodoPago
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = MetodoPagoTmp;

    layout
    {
        area(Content)
        {
            repeater(Pagos)
            {
                field(id; id)
                {
                    ApplicationArea = All;

                }
                field(docNo; docNo)
                {
                    ApplicationArea = All;
                }
                field("Forma de pago"; "Forma de pago")
                {
                    ApplicationArea = All;
                    TableRelation = "Payment Method".Code;
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