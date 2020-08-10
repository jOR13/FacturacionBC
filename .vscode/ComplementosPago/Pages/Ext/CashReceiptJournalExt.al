pageextension 70106 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Forma de pago"; "Forma de pago")
            {
                // CaptionML = ENG = 'Payment method', ESP = 'Forma de pago';
                TableRelation = "Payment Method".code;
                ApplicationArea = All;
            }
        }

        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            var
                cuenta: text;
                gen: Record "Gen. Journal Line";
            begin
                cuenta := rec."Bal. Account No.";
                if cuenta.Contains('213-') then begin
                    rec.EmptyLine();
                end;
            end;
        }
    }

    actions
    {
        modify(Post)
        {

            trigger OnBeforeAction()
            var
                mpt: Record MetodoPagoTmp;
            begin
                if rec."Forma de pago" <> '' then begin
                    mpt.Init();
                    mpt.docNo := rec."Document No.";
                    mpt."Forma de pago" := rec."Forma de pago";
                    mpt.Insert();
                    mpt.id += 1;
                end else
                    Error('Ingrese un metodo de pago');
            end;
        }
    }



}