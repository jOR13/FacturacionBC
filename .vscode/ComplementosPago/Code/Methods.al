codeunit 70101 Methods
{

    procedure getUUIDS()
    var

        fil: Text;
        entry: Integer;
    begin
        fil := '';
        sh.SetFilter(sh.UUIDHG, '<>%1', fil);
        if sh.FindSet() then begin
            repeat begin
                DCLE.Reset();
                DCLE.SetFilter(DCLE."Document No.", sh."No.");
                if DCLE.Findset() then begin
                    repeat begin
                        entry := DCLE."Cust. Ledger Entry No.";
                        insertUUID(entry);
                    end until DCLE.Next() = 0;
                end;
            end until sh.next = 0;
        end;
    end;

    local procedure insertUUID(entry: Integer)
    var
        myInt: Integer;
    begin
        DCLE.Reset();
        DCLE.SetFilter(DCLE."Cust. Ledger Entry No.", Format(entry));
        DCLE.SetFilter(DCLE."Document Type", 'Payment');
        if DCLE.FindSet() then begin
            repeat begin
                DCLE.IdDocumento := sh.UUIDHG;
                DCLE.Modify();
            end until DCLE.Next() = 0;
        end;

    end;

    procedure calcPartial()
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
        p: Record PartialNo;
        i: Integer;
    begin
        //DCLE.SetRange(DCLE."Cust. Ledger Entry No.", 2, 1061);
        DCLE.SetFilter(DCLE."Entry Type", 'Application');
        DCLE.SetFilter(DCLE.Unapplied, 'false');
        //DCLE.SetFilter(DCLE.PartialNo, '0');
        DCLE.SetFilter(DCLE.Amount, '< 0');

        if DCLE.FindSet() then begin
            repeat begin
                PartialNo(DCLE."Cust. Ledger Entry No.");
            end until DCLE.Next() = 0;
        end;
    end;

    local procedure PartialNo(rec: Integer)
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
        p: Record PartialNo;
        i: Integer;
    begin
        DCLE.SetRange(DCLE."Cust. Ledger Entry No.", rec);
        DCLE.SetFilter(DCLE."Entry Type", 'Application');
        DCLE.SetFilter(DCLE.Unapplied, 'false');
        //DCLE.SetFilter(DCLE.PartialNo, '0');
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

    procedure restante(entry: Integer)
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
        cont: Integer;
        val: integer;
        total: decimal;
    begin
        DCLE.SetFilter(DCLE."Cust. Ledger Entry No.", Format(entry));
        cont := DCLE.count;
        DCLE.FindSet();
        for val := 1 to cont do begin
            DCLE.SetFilter(DCLE."Cust. Ledger Entry No.", Format(entry));
            DCLE.SetRange(DCLE.PartialNo, 1, val);
            total += DCLE.Amount;
            DCLE.SaldoRestante := total;
            DCLE.Modify();
            DCLE.Next();
            DCLE.Reset();
        end;

    end;

    var

        sh: record "Sales Invoice Header";
        DCLE: record "Detailed Cust. Ledg. Entry";
        myInt: Integer;
}