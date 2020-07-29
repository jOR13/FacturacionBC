
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

        field(50856; FechaDeEntrega; date)
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

        field(50859; DescAdicional; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        //gas

        field(50860; NoTicket; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        field(50861; FechaEntregaGas; Date)
        {
            DataClassification = ToBeClassified;
        }

        //Diesel

        field(50862; RemisonDiesel; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        field(50863; FechaEntregaDiesel; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(70105; "No. identificacion"; Text[250])
        {
            DataClassification = ToBeClassified;
            //TableRelation = if ("Location Code" = filter(<> '')) Location.PermisoCode where(PermisoCode = filter(<> ''));
            TableRelation = Location.PermisoCode where(PermisoCode = filter(<> ''));
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
            group(Relacion)
            {
                field("Tipo relacion"; "Tipo relacion")
                {
                    ApplicationArea = all;
                    //Caption = 'Tipo de documento a relacionar';
                    CaptionML = ENU = 'Document type to relate', ESP = 'Tipo de documento a relacionar';

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        "UUID Relation HG" := '';
                        stat := true;
                    end;
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
        }

        addafter("CFDI Relation")
        {


            group(Turbosina)
            {
                field(aeropuerto; aeropuerto)
                {
                    CaptionML = ESP = 'Aeropuerto', ENU = 'Airport';
                    ApplicationArea = all;
                    TableRelation = Aeropuertos.aeropuerto;
                }

                field(BOL; BOL)
                {
                    CaptionML = ESP = 'BOL', ENU = 'Bill of Landing';
                    ApplicationArea = all;
                    TableRelation = BillOfLanding.NoBol;
                }


                field(NoTanque; NoTanque)
                {
                    CaptionML = ESP = 'Numero de tanque', ENU = 'Tank number';
                    ApplicationArea = all;
                    TableRelation = tanque.NoTanque;
                }

                field(PeriodoFact; PeriodoFact)
                {
                    CaptionML = ESP = 'Periodo de facturación', ENU = 'Billing period';
                    ApplicationArea = all;

                }
            }

            group(Transportadora)
            {
                field(OrigenDestino; OrigenDestino)
                {
                    CaptionML = ENU = 'Origin and Destination', ESP = 'Origen y destino';
                    ApplicationArea = all;
                }

                field(Remision; Remision)
                {
                    ApplicationArea = all;
                    CaptionML = ESP = 'Remision', ENU = 'Remission';

                }

                field(FechaDeEntrega; FechaDeEntrega)
                {
                    CaptionML = ESP = 'Fecha de entrega', ENU = 'Delivery date';
                    ApplicationArea = all;
                }

                field(Tanque; Tanque)
                {
                    CaptionML = ESP = 'Numero de tanque', ENU = 'Number tank';
                    ApplicationArea = all;
                }

                field(ProductoTrasnportado; ProductoTrasnportado)
                {
                    ApplicationArea = all;
                    CaptionML = ESP = 'Producto transportado', ENU = 'Item product transported';
                }
            }

            group(Gas)
            {
                field(NoTicket; NoTicket)
                {
                    ApplicationArea = All;
                    CaptionML = ESP = 'Numero de ticket', ENU = 'Ticket number';
                    TableRelation = "Sales Header"."Location Code" where("Location Code" = field("Location Code"));
                }

                field(FechaEntregaGas; FechaEntregaGas)
                {
                    CaptionML = ESP = 'Fecha de entrega', ENU = 'Delivery date';
                    ApplicationArea = All;
                }
            }

            group(Diesel)
            {
                field(RemisonDiesel; RemisonDiesel)
                {
                    ApplicationArea = All;
                    CaptionML = ESP = 'Remisión', ENU = 'Remission';
                }

                field(FechaEntregaDiesel; FechaEntregaDiesel)
                {
                    CaptionML = ESP = 'Fecha de entrega', ENU = 'Delivery date';
                    ApplicationArea = All;
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

        modify("Work Description")
        {
            Visible = false;
        }

        modify("WorkDescription")
        {
            Visible = false;
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

                if rec."Currency Code" = '' then begin
                    Error('Por favor llene los campos requeridos');
                end;
            end;
        }

        modify("Currency Code")
        {
            ShowMandatory = true;
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

        addlast("Shipping and Billing")
        {
            group(Permisos)
            {
                field("No. identificacion"; "No. identificacion")
                {

                    ApplicationArea = all;
                    TableRelation = Location.PermisoCode where(PermisoCode = filter(<> ''));

                }
            }

        }


    }
    var
        show: Boolean;
        stat: Boolean;
}
