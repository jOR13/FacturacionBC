
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

        field(50522; "UUID Relation HG"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50523; "Tipo relacion"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Seleccione","Facturas","Notas de credito";

        }

        //turbosina
        field(50849; aeropuerto; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(50850; BOL; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(50851; Pedimento; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(50852; NoTanque; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(50853; PeriodoFact; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        //trasnportadora

        field(50854; OrigenDestino; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50855; Remision; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50856; FechaDeEntrega; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50857; Tanque; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50858; ProductoTrasnportado; text[250])
        {
            DataClassification = ToBeClassified;
        }

    }

    fieldgroups
    {
        addlast(DropDown; aeropuerto)
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
        addafter("Work Description")
        {
            field("Tipo relacion"; "Tipo relacion")
            {
                ApplicationArea = all;
                //Caption = 'Tipo de documento a relacionar';
                CaptionML = ENG = 'Document type to relate', ESP = 'Tipo de documento a relacionar';

                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    stat := true;
                end;

                /* trigger OnValidate()
                 var
                     msg: TextConst ESP = 'Esta factura ya ha sido timbrada, no puede agregar o modificar', ENU = 'This invoice has already been stamped, it cannot be insert or modified';
                 begin
                     show := false;
                     if (UUIDHG = '') then begin
                         stat := true;
                         "UUID Relation HG" := '';
                     end else begin
                         Message(msg);
                         "Tipo relacion" := 0;
                         stat := false;
                     end;

                 end;*/
            }
            field("UUID Relation"; "UUID Relation HG")
            {
                ApplicationArea = All;
                Editable = stat;
                Style = Favorable;
                TableRelation = if ("Tipo relacion" = const(2)) "Sales Cr.Memo Header".UUIDNCHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDNCHG = filter(<> ''))
                else
                if ("Tipo relacion" = const(1)) "Sales Invoice Header".UUIDHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDHG = filter(<> ''));

            }
        }

        addafter("CFDI Relation")
        {

            group(Turbosina)
            {
                field(aeropuerto; aeropuerto)
                {
                    CaptionML = ESP = 'Aeropuerto', ENG = 'Airport';
                    ApplicationArea = all;
                    TableRelation = Aeropuertos.aeropuerto;
                }

                field(BOL; BOL)
                {
                    CaptionML = ESP = 'BOL', ENG = 'Bill of Landing';
                    ApplicationArea = all;
                    TableRelation = BillOfLanding.NoBol;
                }

                field(Pedimento; Pedimento)
                {
                    CaptionML = ESP = 'Pedimento', ENG = 'Pedimento';
                    ApplicationArea = all;
                    TableRelation = PedimentosTableHG.Pedimento;
                }

                field(NoTanque; NoTanque)
                {
                    CaptionML = ESP = 'Numero de tanque', ENG = 'Tank number';
                    ApplicationArea = all;
                    TableRelation = tanque.NoTanque;
                }

                field(PeriodoFact; PeriodoFact)
                {
                    CaptionML = ESP = 'Periodo de facturación', ENG = 'Billing period';
                    ApplicationArea = all;

                }
            }

            group(Transportadora)
            {
                field(OrigenDestino; OrigenDestino)
                {
                    ApplicationArea = all;
                }

                field(Remision; Remision)
                {
                    ApplicationArea = all;
                }

                field(FechaDeEntrega; FechaDeEntrega)
                {
                    ApplicationArea = all;
                }

                field(Tanque; Tanque)
                {
                    ApplicationArea = all;
                }

                field(ProductoTrasnportado; ProductoTrasnportado)
                {
                    ApplicationArea = all;
                }
            }

        }

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

        show: Boolean;
        stat: Boolean;
}
