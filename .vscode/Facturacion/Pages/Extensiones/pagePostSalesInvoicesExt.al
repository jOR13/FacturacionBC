pageextension 50506 pagePostSalesInvoicesExt extends 143
{
    Editable = true;

    //Permissions = TableData 112 = rimd;
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
                TableRelation = if ("Tipo relacion" = const(2)) "Sales Cr.Memo Header".UUIDNCHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDNCHG = filter(<> ''))
                else
                if ("Tipo relacion" = const(1)) "Sales Invoice Header".UUIDHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDHG = filter(<> ''));

            }
            field("Fecha de timbrado"; "Fecha de timbrado")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Stamp date', ESP = 'Fecha de timbrado';
            }

            field("Estado del CFDI"; "Estado del CFDI")
            {
                ApplicationArea = All;
                Style = Favorable;
                TableRelation = if ("Estado del CFDI" = const('')) EstadoCDFITable.status where(Folio = field("No."));
                trigger OnDrillDown()
                var
                    SCFDI: Codeunit StatusCFDI;
                    st: Record EstadoCDFITable;
                begin
                    if st.FindSet() then begin
                        repeat begin
                            st.status := SCFDI.GetSatusCFDI('CCD070607PL6', rec.RFCR, Rec.TotalFactura, Rec.UUIDHG).ToUpper();
                            st.Folio := rec."No.";
                        end until st.next = 0;
                        st.Modify();
                        Update();
                    end else begin
                        st.status := SCFDI.GetSatusCFDI('CCD070607PL6', rec.RFCR, Rec.TotalFactura, Rec.UUIDHG).ToUpper();
                        st.Folio := rec."No.";
                        st.Insert();
                        st.id := st.id + 1;
                    end;

                end;
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
                        reporteTransportadora: Report HG_ReportTrasnportadoraFact;
                        reporteTurbosina: Report HG_ReprteTurbosina;
                        reporteGas: report HG_GasCfdi;
                        reporteDiesel: Report HG_DieselCFDI;
                        cod: Codeunit codeUnitWS;
                        temp: Record temporal;
                        facturas: Record facturas_Timbradas;
                        msg: TextConst ESP = 'La factura no se ha timbrado', ENU = 'The invoice has not been stamped';
                    begin
                        if rec.UUIDHG = '' then begin
                            Message(msg);
                            temp.DeleteAll();
                        end else begin
                            facturas.SetFilter(facturas.Folio, rec."No.");
                            temp.Init();
                            temp.getRec := Rec."No.";
                            temp.DocNo := Rec."Order No.";
                            if temp.Insert() = false then begin
                                temp.DeleteAll();
                            end;
                            Commit();
                            if (Rec.Remision <> '') or (rec.ProductoTrasnportado <> '') or (Rec.FechaDeEntrega <> 0D) or (Rec.OrigenDestino <> '') or (rec.Tanque <> '') then begin
                                reporteTransportadora.RunModal();
                                temp.DeleteAll();
                                Clear(reporteTransportadora);
                            end else
                                if (Rec.FechaEntregaGas <> 0D) or (Rec.NoTicket <> '') then begin
                                    reporteGas.RunModal();
                                    temp.DeleteAll();
                                    Clear(reporteGas);
                                end else
                                    if (Rec.FechaEntregaDiesel <> 0D) or (Rec.RemisonDiesel <> '') then begin
                                        reporteDiesel.RunModal();
                                        temp.DeleteAll();
                                        Clear(reporteDiesel);
                                    end else
                                        if (Rec.aeropuerto <> '') or (rec.PeriodoFact <> '') or (Rec.BOL <> '') or (Rec.NoTanque <> '') then begin
                                            reporteTurbosina.RunModal();
                                            temp.DeleteAll();
                                            Clear(reporteTurbosina);
                                        end else begin
                                            reporte.RunModal();
                                            temp.DeleteAll();
                                            Clear(reporte);
                                        end;

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
                        cod: Codeunit GetJsonNC;
                        qry: Query QrySIH;
                        CurrentDate: date;
                    begin
                        HYPERLINK('http://192.168.1.73/timbrado/facturas');
                        c.calCImporteTraslado();
                        cod.calCImporteTrasladoNC();
                        // cod.NCtimbradas();
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
                            Error('Esta factura no se ha timbrado');
                        end;
                    end;
                }


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
                        myclass.abrirFactura(Rec);
                    end;
                }


                action("Subir XML")
                {
                    Image = MoveUp;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        up: Codeunit UploadXML;
                        FileName: Text;
                        TestFile: File;
                        NVInStream: InStream;
                        textoXML: Text;
                        texto, newtxt : Text;
                        msg: TextConst ESP = 'Seleccione la factura a cargar', ENU = 'Select the invoice to upload';
                        pagina: page "Posted Sales Invoices";
                        page: page "Posted Sales Invoice";
                        tabla: record "Sales Invoice Header";
                    begin
                        UPLOADINTOSTREAM(msg, 'c:\', ' .xml (*.xml*)|*.xml*', FileName, NVInStream);
                        NVInStream.ReadText(textoXML, 99999999);
                        newtxt := textoXML.Replace('Ù‹', '');
                        texto := up.ReadXML(newtxt);
                        pagina.Close();
                        pagina.SetSelectionFilter(Rec);
                        rec.SetFilter(rec."No.", texto);
                        pagina.Update();
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

        mitabla: Record "Sales Invoice Header";
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


