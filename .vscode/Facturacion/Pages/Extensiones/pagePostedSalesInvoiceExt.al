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
            /*
                        usercontrol(html; HTML)
                        {
                            ApplicationArea = all;
                            trigger ControlReady()
                            begin
                                CurrPage.html.Render('<a href="https://getqr20200623153401.azurewebsites.net/api/Function1?code=lJW53R67tThalGjzTmdQwg1GJrrFjBmPz7URpaGrAFY6fSFacyEG3A==&data=' + "Verifica Factura" + '">Mostrar codigo QR</a>');
                                //CurrPage.html.Render(CreateTable(10, 8));
                            end;
                        }*/



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
                                        end
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
                        if TempBlob.TryDownloadFromUrl('http://hgwebapp.azurewebsites.net/api/xml/' + Rec."No.") then begin
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


                /*
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
                                        texto: Text;
                                        msg: TextConst ESP = 'Seleccione la factura a cargar', ENU = 'Select the invoice to upload';
                                        pagina: page "Posted Sales Invoices";
                                        page: page "Posted Sales Invoice";
                                        tabla: record "Sales Invoice Header";
                                    begin
                                        UPLOADINTOSTREAM(msg, 'c:\', ' .xml (*.xml*)|*.xml*', FileName, NVInStream);
                                        NVInStream.ReadText(textoXML, 99999999);
                                        texto := up.ReadXML(textoXML);
                                        pagina.Close();
                                        pagina.SetSelectionFilter(Rec);
                                        rec.SetFilter(rec."No.", texto);
                                        pagina.Update();
                                        //pagina.Run();
                                    end;
                                }*/
            }
        }
    }


    var

        c: Codeunit codeUnitWS;

}