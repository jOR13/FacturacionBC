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
    }

    var
        myInt: Integer;
}