page 70102 Permisos
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = permisosCRE;

    layout
    {
        area(Content)
        {
            group(Permisos)
            {

                field(id; id)
                {
                    ApplicationArea = All;
                }
                field(Cliente; Cliente)
                {
                    ApplicationArea = All;
                }
                field("No. Permiso"; "No. Permiso")
                {
                    ApplicationArea = All;
                }
                field(code; code)
                {
                    ApplicationArea = All;
                }
                field(Comercializacion; Comercializacion)
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