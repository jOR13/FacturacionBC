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
                CaptionML = ENG = 'Document type to relate', ESP = 'Tipo de documento a relacionar';

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
                    CaptionML = ENG = 'Airport', ESP = 'Aeropuerto';
                    ApplicationArea = all;
                    TableRelation = Aeropuertos.aeropuerto;
                }
                field(BOL; BOL)
                {
                    CaptionML = ENG = 'Bill of Landing', ESP = 'BOL';
                    ApplicationArea = all;
                    TableRelation = BillOfLanding.NoBol;
                }
                field(NoTanque; NoTanque)
                {
                    CaptionML = ENG = 'Tank number', ESP = 'Numero de tanque';
                    ApplicationArea = all;
                    TableRelation = tanque.NoTanque;
                }
                field(PeriodoFact; PeriodoFact)
                {
                    CaptionML = ENG = 'Billing period', ESP = 'Periodo de facturación';
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