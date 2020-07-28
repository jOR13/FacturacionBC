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
            action(PartialNO)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    cod: Codeunit Methods;
                    DCLE: Record "Detailed Cust. Ledg. Entry";
                    p: Record PartialNo;
                    i: Integer;
                begin
                    // DCLE.SetRange(DCLE."Cust. Ledger Entry No.", 2, 1061);
                    if DCLE.FindSet() then begin
                        repeat begin
                            cod.PartialNo(DCLE."Cust. Ledger Entry No.");
                        end until DCLE.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}