pageextension 50505 pagePostedSalesInvoiceExt extends "Posted Sales Invoice"
{

    layout
    {

        modify("Work Description")
        {
            Visible = false;
        }


        addafter("Work Description")
        {
            group(Relacion)
            {
                field("Tipo relacion"; "Tipo relacion")
                {
                    ApplicationArea = all;
                    //Caption = 'Tipo de documento a relacionar';
                    CaptionML = ENU = 'Document type to relate', ESP = 'Tipo de documento a relacionar';

                }
                field("UUID Relation"; "UUID Relation HG")
                {
                    ApplicationArea = All;

                }
            }

        }
        addbefore("Work Description")
        {
            group(Turbosina)
            {
                Description = 'Seccion para agregar al PDF de la factura';
                field(aeropuerto; aeropuerto)
                {
                    CaptionML = ENU = 'Airport', ESP = 'Aeropuerto';
                    ApplicationArea = all;
                    TableRelation = Aeropuertos.aeropuerto;
                }
                field(BOL; BOL)
                {
                    CaptionML = ENU = 'Bill of Landing', ESP = 'BOL';
                    ApplicationArea = all;
                    TableRelation = BillOfLanding.NoBol;
                }
                field(NoTanque; NoTanque)
                {
                    CaptionML = ENU = 'Tank number', ESP = 'Numero de tanque';
                    ApplicationArea = all;
                    TableRelation = tanque.NoTanque;
                }
                field(PeriodoFact; PeriodoFact)
                {
                    CaptionML = ENU = 'Billing period', ESP = 'Periodo de facturación';
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
    }

    var

}