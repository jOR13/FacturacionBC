codeunit 70101 Methods
{
    // procedure SerieNO()
    // var
    //     number: Integer;
    //     permiso: Record PermisosCRE;
    // begin

    //     if permiso.FindSet() then begin
    //         Message('%1', permiso.Get());
    //     end else begin
    //         Message('NO se encontro registro');
    //     end;
    // end;

    [EventSubscriber(ObjectType::table, database::"Detailed Cust. Ledg. Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure calcPartial()
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
        p: Record PartialNo;
        i: Integer;
    begin
        // DCLE.SetRange(DCLE."Cust. Ledger Entry No.", 2, 1061);
        DCLE.SetFilter(DCLE."Entry Type", 'Application');
        DCLE.SetFilter(DCLE.Unapplied, 'false');
        DCLE.SetFilter(DCLE.PartialNo, '0');
        DCLE.SetFilter(DCLE.Amount, '< 0');

        if DCLE.FindSet() then begin
            repeat begin
                PartialNo(DCLE."Cust. Ledger Entry No.");
            end until DCLE.Next() = 0;
        end;
    end;

    procedure PartialNo(rec: Integer)
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
        p: Record PartialNo;
        i: Integer;
    begin
        DCLE.SetRange(DCLE."Cust. Ledger Entry No.", rec);
        DCLE.SetFilter(DCLE."Entry Type", 'Application');
        DCLE.SetFilter(DCLE.Unapplied, 'false');
        DCLE.SetFilter(DCLE.PartialNo, '0');
        DCLE.SetFilter(DCLE.Amount, '< 0');
        i := 1;
        if DCLE.FindSet() then begin
            repeat begin
                DCLE.PartialNo := i;
                i := i + 1;
                DCLE.Modify();
            end until DCLE.Next() = 0;
        end;
        i := 0;
    end;

    var
        myInt: Integer;
}