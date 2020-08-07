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

    trigger OnInsert()
    var
        myInt: Integer;
    begin

        if (rec.TipoCambio = 0) and (rec.Amount <> 0) and (rec."Amount (LCY)" <> 0) then begin
            rec.TipoCambio := rec."Amount (LCY)" / rec.Amount;
            rec.Modify();
            Message('tipo de cambio %1', rec.TipoCambio);
        end;

    end;

}