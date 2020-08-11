pageextension 70106 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Forma de pago"; "Forma de pago")
            {
                ShowMandatory = true;
                TableRelation = "Payment Method".code;
                ApplicationArea = All;
            }
        }

        modify(Amount)
        {
            ShowMandatory = true;
        }
        modify("Amount (LCY)")
        {
            ShowMandatory = true;
        }

        modify("Bal. Account No.")
        {
            ShowMandatory = true;
            /*trigger OnAfterValidate()
            var
                cuenta: text;
                gen: Record "Gen. Journal Line";
                cont: INTEGER;
                p: Page "Cash Receipt Journal";
            begin
                cuenta := rec."Bal. Account No.";
                if cuenta.Contains('213-') then begin
                    stat := false;
                end else
                    stat := true;
            end;*/
        }


    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
            begin
                if (rec."Forma de pago" <> '') then begin
                    mpt.Init();
                    mpt.docNo := rec."Document No.";
                    mpt."Forma de pago" := rec."Forma de pago";
                    mpt.Insert();
                    mpt.id += 1;
                end else
                    Error('Ingrese un metodo de pago');

                /*cuenta := rec."Bal. Account No.";
                if cuenta.Contains('213-') then begin
                    Error('Favor de generar la linea de IVA para el anticipo antes de registrar');
                end;*/
            end;
        }

        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if (rec."Forma de pago" <> '') then begin
                    mpt.Init();
                    mpt.docNo := rec."Document No.";
                    mpt."Forma de pago" := rec."Forma de pago";
                    mpt.Insert();
                    mpt.id += 1;
                end else
                    Error('Ingrese un metodo de pago');

                /*cuenta := rec."Bal. Account No.";
                if cuenta.Contains('213-') then begin
                    Error('Favor de generar la linea de IVA para el anticipo antes de registrar');
                end;*/
            end;
        }


    }
    var
        stat: Boolean;
        cuenta: text;
        mpt: Record MetodoPagoTmp;

}
