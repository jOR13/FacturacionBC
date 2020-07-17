pageextension 60512 pageSalesCreditMemoExt extends "Sales Credit Memo"
{
    layout
    {
        modify("CFDI Relation")
        {
            ShowMandatory = true;

        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
            begin
                if (Rec."Applies-to Doc. No." <> '') and (rec."CFDI Relation" = '') then begin
                    Error('Cuando la nota de credito tiene una relacion a alguna factura se necesita especificar el tipo de relacion, por favor llene el campo');
                end;
            end;
        }
    }





    var
        myInt: Integer;
}