tableextension 70107 DetailedCustLedgerEntry extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(70107; PartialNo; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(70108; TipoCambio; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(7010; IdDocumento; text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header".UUIDHG where("No." = field("Document No."));

        }

        field(707101; SaldoRestante; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    trigger OnAfterInsert()
    var
        uuid: text;
    begin

        if (rec.TipoCambio = 0) and (rec.Amount <> 0) and (rec."Amount (LCY)" <> 0) then begin
            rec.TipoCambio := rec."Amount (LCY)" / rec.Amount;
            rec.Modify();
        end;

        cod.restante(rec."Cust. Ledger Entry No.");

        rec.SetFilter("Cust. Ledger Entry No.", Format(rec."Cust. Ledger Entry No."));
        rec.SetFilter("Entry Type", 'Initial Entry');
        rec.SetFilter("Document Type", 'Invoice');

        if rec.FindSet() then begin
            if sh.get(rec."Document No.") then begin
                sh.Find('=');
                uuid := sh.UUIDHG;
                rec.Reset();

                if uuid <> '' then begin
                    rec.SetFilter("Cust. Ledger Entry No.", Format(rec."Cust. Ledger Entry No."));
                    if rec.FindSet() then begin
                        repeat begin
                            rec.IdDocumento := uuid;
                            rec.Modify();
                        end until rec.Next() = 0;
                    end;
                end;
            end;
        end;


    end;

    trigger OnAfterModify()
    begin

    end;

    var

        cod: Codeunit Methods;
        sh: record "Sales Invoice Header";
        fil: Text;
}

