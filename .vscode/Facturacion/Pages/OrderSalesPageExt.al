
tableextension 50848 OrderSalesPageExt extends "Sales Header"
{
    fields
    {
        modify("Payment Method Code")
        {
            TableRelation = Conceptos;

        }

        field(50848; pagos; Text[250])
        {

        }
    }

    var
        myInt: Integer;
}

pageextension 50848 MyExtension extends "Sales Order"
{
    layout
    {
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                rec."Payment Method Code" := '';
                rec.pagos := '';
            end;
        }

        modify("CFDI Purpose")
        {
            ShowMandatory = true;
        }

        modify("Payment Method Code")
        {
            Enabled = false;
            Visible = false;
            ShowMandatory = true;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if rec."Payment Method Code" = '' then begin
                    Error('Por favor llene este campo.');
                end;
            end;
        }

        modify("Posting Date")
        {
            ShowMandatory = true;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if rec.pagos = '' then begin
                    Error('Por favor llene los campos requeridos');
                end;

                if rec."CFDI Purpose" = '' then begin
                    Error('Por favor llene los campos requeridos');
                end;
            end;
        }


        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if rec.pagos = '' then begin
                    rec."Payment Terms Code" := '';
                    rec."Payment Method Code" := '';
                end;
            end;
        }

        addbefore("Payment Method Code")
        {

            field(pagos; pagos)
            {
                ShowMandatory = true;
                ApplicationArea = All;
                Caption = 'Payment Method Code';
                TableRelation = IF ("Payment Terms Code" = const('0')) "Payment Method".Code where("SAT Method of Payment" = filter('<>99'))
                else
                "Payment Method".Code where("SAT Method of Payment" = filter('99'));

                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    rec."Payment Method Code" := rec.pagos;
                end;

            }
        }
    }



    var
        myInt: Integer;
}
