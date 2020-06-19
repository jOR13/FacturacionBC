pageextension 50505 pagePostedSalesInvoiceExt extends "Posted Sales Invoice"
{

    layout
    {


        addafter("Work Description")
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
    }

    var

}