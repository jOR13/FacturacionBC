pageextension 70107 DetailedCustLedgerEntry extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addfirst(Control1)
        {
            field(PartialNo; PartialNo)
            {
                ApplicationArea = all;
            }

        }

        addafter("Amount (LCY)")
        {
            field(SaldoRestante; SaldoRestante)
            {
                ApplicationArea = all;
            }
        }

        addafter("Entry No.")
        {
            field(IdDocumento; IdDocumento)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            group("Facturación electrónica HG")
            {
                Image = Invoice;
                CaptionML = ENU = 'Electronic invoice', ESP = 'Facturación electrónica';
                Visible = true;
                action("PDF de la Factura")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    CaptionML = ENU = 'Invoice PDF', ESP = 'PDF de la factura';
                    PromotedCategory = Process;
                    Image = Report;
                    Visible = true;
                    trigger OnAction()
                    var

                    begin

                    end;
                }

                action("Timbrar facturas")
                {
                    ApplicationArea = All;
                    Image = AddAction;
                    CaptionML = ENU = 'Stamp invoice', ESP = 'Timbrar facturas';
                    Visible = true;
                    trigger OnAction()
                    var
                        cod: Codeunit GetJsonNC;
                        qry: Query QrySIH;
                        CurrentDate: date;
                    begin
                        HYPERLINK('http://192.168.1.73/timbrado/complementosdepago');

                    end;
                }

                action("DownloadXML")
                {
                    image = CreateXMLFile;
                    ApplicationArea = All;
                    CaptionML = ENU = 'Download XML', ESP = 'Descargar XML';
                    Visible = true;
                    trigger OnAction()
                    var

                    begin

                    end;
                }

                action("Envio por correo")
                {
                    Image = SendEmailPDF;
                    ApplicationArea = all;
                    CaptionML = ENU = 'Send Email', ESP = 'Enviar correo';
                    Visible = true;
                    trigger OnAction()
                    var

                    begin

                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}



