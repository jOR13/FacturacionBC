pageextension 50506 pagePostSalesInvoicesExt extends 143
{
    Editable = true;

    layout
    {
        modify("No.")
        {
            Style = Favorable;
            StyleExpr = color;
        }
        addafter("Location Code")
        {
            field(UUID; UUIDHG)
            {
                Caption = 'UUID';
                ApplicationArea = all;
            }
        }

        addafter(UUID)
        {
            field("UUID Relation"; "UUID Relation HG")
            {
                CaptionML = ENU = 'UUID Relation', ESP = 'UUID Relacionado';
                ApplicationArea = All;
                Visible = true;
                Style = Favorable;
                TableRelation = UUIDRelacionados."UUID Relacionado" where(Folio = field("No."));
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
                action("PDF de la Factura")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    CaptionML = ENU = 'Invoice PDF', ESP = 'PDF de la factura';
                    PromotedCategory = Process;
                    Image = Report;
                    trigger OnAction()
                    var
                        reporte: Report HG_ReporteCFDI;
                        cod: Codeunit codeUnitWS;
                        temp: Record temporal;
                        facturas: Record facturas_Timbradas;
                        msg: TextConst ESP = 'La factura no se ha timbrado', ENU = 'The invoice has not been stamped';
                    begin
                        if rec.UUIDHG = '' then begin
                            Message(msg);
                        end else begin
                            facturas.SetFilter(facturas.Folio, rec."No.");
                            temp.Init();
                            temp.getRec := Rec."No.";
                            temp.DocNo := Rec."Order No.";
                            temp.Insert();
                            Commit();
                            reporte.RunModal();
                            temp.DeleteAll();
                            Clear(reporte);
                        end;
                    end;
                }

                action("Timbrar facturas")
                {
                    ApplicationArea = All;
                    Image = AddAction;
                    CaptionML = ENU = 'Stamp invoice', ESP = 'Timbrar facturas';
                    trigger OnAction()
                    var
                        cod: Codeunit getStamp;
                        qry: Query QrySIH;
                        CurrentDate: date;
                    begin
                        HYPERLINK('http://192.168.1.73');
                        c.calCImporteTraslado();
                        c.calCImporteTrasladoNC();
                        // cod.NCtimbradas();
                    end;
                }
                action("Refrescar timbradas")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Refresh list', ESP = 'Refrescar lista';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = CalculateLines;
                    trigger OnAction();
                    var
                        page: Page facturas;
                    begin
                        page.RunModal();
                        c.Refresh();
                        CurrPage.Update;
                        Commit();


                    end;
                }

                action("Descargar XML")
                {
                    image = CreateXMLFile;
                    ApplicationArea = All;
                    CaptionML = ENU = 'Download XML', ESP = 'Descargar XML';
                    /*trigger onAction()
                    var
                        myInt: Integer;
                    begin
                        HYPERLINK('http://192.168.1.73/timbrado/xmlasync/$' + rec."No.");
                    end;*/

                    trigger onAction()
                    var
                        myInt: Integer;
                        myPage: Page "Detailed Cust. Ledg. Entries";
                    begin
                        mitabla.Get("Entry No.");
                        mitabla.CalcFields(mitabla.XML);
                        mitabla.XML.CreateInStream(mystream, tipocode::UTF8);
                        myInt := mystream.Read(texto);
                        txt := mitabla."Document No." + '.xml';
                        DownloadFromStream(mystream, '', '', '', txt);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if UUIDHG <> '' then begin
            color := true;
        end else begin
            color := false;
        end;
    end;

    var

        mitabla: Record "Detailed Cust. Ledg. Entry";
        OutStr: OutStream;
        myInt: Integer;
        mystream: InStream;
        tipocode: TextEncoding;
        texto: Text;
        testfile: File;
        txt: text;
        c: Codeunit codeUnitWS;
        color: Boolean;
}


