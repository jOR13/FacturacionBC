pageextension 50845 PostedSalesCreditMemos extends "Posted Sales Credit Memos"
{


    layout
    {
        modify("No.")
        {
            Style = Favorable;
            StyleExpr = color;
        }

        addafter("Location Code")
        {
            field(UUID; UUIDNCHG)
            {
                ApplicationArea = all;
                Caption = 'UUID';
                Style = Favorable;
                StyleExpr = color;
            }

            field(UUIDRelacionadoNC; UUIDRelacionadoNC)
            {
                Caption = 'UUID Relacionado';
                ApplicationArea = all;
                TableRelation = facturas_Timbradas.UUID where(Folio = field("Applies-to Doc. No."));

            }

            field("Fecha de timbrado"; "Fecha de timbrado")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Stamp date', ESP = 'Fecha de timbrado';
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
                action("PDF de la NC")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    CaptionML = ENU = 'Invoice PDF', ESP = 'PDF de la NC';
                    PromotedCategory = Process;
                    Image = Report;
                    trigger OnAction()
                    var
                        reporte: Report HG_NotaDeCredito;
                        cod: Codeunit GetJsonNC;
                        temp: Record temporal;
                        nc: Record NCTimbradas;
                        msg: TextConst ESP = 'La NC no se ha timbrado', ENU = 'The invoice has not been stamped';
                    begin
                        if rec.UUIDNCHG = '' then begin
                            Message(msg);
                            temp.DeleteAll();
                        end else begin
                            temp.Init();
                            temp.DeleteAll();
                            temp.getRec := Rec."No.";
                            if temp.Insert() = false then begin
                                temp.Modify();
                            end;
                            Commit();
                            reporte.RunModal();
                        end;
                    end;
                }

                action("Timbrar facturas")
                {
                    ApplicationArea = All;
                    Image = AddAction;
                    CaptionML = ENU = 'Stamp invoice', ESP = 'Timbrar NC';
                    trigger OnAction()
                    var
                        cod: Codeunit GetJsonNC;
                        qry: Query QrySIH;
                        CurrentDate: date;
                    begin
                        HYPERLINK('http://192.168.1.73/timbrado/notasdecredito');
                        cod.calCImporteTrasladoNC();
                    end;
                }

                action("DownloadXML")
                {
                    image = CreateXMLFile;
                    ApplicationArea = All;
                    CaptionML = ENU = 'Download XML', ESP = 'Descargar XML';
                    trigger onAction()
                    var
                        myInt: Integer;
                        TempBlob: Record TempBlob temporary;
                        XMLIStream: InStream;
                        FileName: Text;
                    begin
                        //HYPERLINK('http://192.168.1.73/timbrado/xmlasync/' + rec."No.");
                        clear(TempBlob);
                        TempBlob.Blob.CreateInStream(XMLIStream);
                        FileName := Rec."No." + '.XML';
                        if TempBlob.TryDownloadFromUrl('http://177.244.51.250:2020/api/xml/' + Rec."No.") then begin
                            DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);
                        end else begin
                            Error('Esta NC no se ha timbrado');
                        end;
                    end;
                }

                group("Enviar PDF")
                {
                    Image = SendMail;

                    action("Envio por correo")
                    {
                        Image = SendEmailPDF;
                        ApplicationArea = all;
                        CaptionML = ENU = 'Send Email', ESP = 'Enviar correo';
                        trigger OnAction()
                        var
                            myInt: Integer;
                            myclass: Codeunit ControlEventos;
                        begin
                            myclass.abrirNC(Rec);
                        end;
                    }
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if UUIDNCHG <> '' then begin
            color := true;
        end else begin
            color := false;
        end;
    end;

    var
        color: Boolean;
        SCFDI: Codeunit StatusCFDI;
}