page 70102 "Permisos CRE"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = permisosCRE;

    layout
    {
        area(Content)
        {
            repeater(Permisos)
            {

                field(id; id)
                {
                    ApplicationArea = All;
                }
                /* field(Cliente; Cliente)
                 {
                     ApplicationArea = All;
                 }*/
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
            action(Serie)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    cod: Codeunit Methods;
                begin
                    Message('dasd');
                    cod.SerieNO();
                end;
            }
        }
    }

    var
        myInt: Integer;
}