codeunit 60120 ControlEventos
{
    procedure abrirFactura(Invoice: Record "Sales Invoice Header")
    var
        myInt: Integer;
    begin
        mytable.DeleteAll();
        company.get;
        cliente.get(Invoice."Bill-to Customer No.");
        mytable.Para := cliente."E-Mail";
        mytable.Asunto := company.Name;
        mytable.Cliente := cliente."No.";
        mytable.Factura := Invoice."No.";
        mytable.Archivo := mytable.Archivo::xmlYpdf;
        mytable.importe := Format(Invoice."Amount Including VAT", 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
        mytable.Insert(true);
        Commit();
        mypage.Run();
    end;

    /*
     procedure abrirNC(NotaCredito: Record "Sales Cr.Memo Header")
     var
         myInt: Integer;
     begin
         mytable.DeleteAll();
         company.get;
         cliente.get(NotaCredito."Bill-to Customer No.");
         mytable.IsCreditNote := true;
         mytable.Para := cliente."E-Mail";
         mytable.Asunto := company.Name;
         mytable.Cliente := cliente."No.";
         mytable.Factura := NotaCredito."No.";
         mytable.Archivo := mytable.Archivo::Ambos;
         mytable.importe := Format(NotaCredito."Amount Including VAT", 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
         mytable.Insert(true);
         Commit();
         mypage.Run();
     end;
    */

    procedure abrirPago(CustLedgerEntry: Record "Detailed Cust. Ledg. Entry")
    var
        myInt: Integer;
    begin
        mytable.DeleteAll();
        company.get;
        cliente.get(CustLedgerEntry."Customer No.");
        mytable.Para := cliente."E-Mail";
        mytable.Asunto := company.Name;
        mytable.Cliente := cliente."No.";
        mytable.Factura := CustLedgerEntry."Document No.";
        mytable."Entry No" := CustLedgerEntry."Entry No.";
        mytable.Archivo := mytable.Archivo::xmlYpdf;
        mytable.importe := Format(CustLedgerEntry.Amount, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
        mytable.Insert(true);
        Commit();
        mypage.Run();
    end;
    /*
        procedure envioCorreoNC(Numcliente: Text;
        invoice: text): Boolean
        var
            myInt: Integer;
            mail: Codeunit "SMTP Mail";
            mailSetup: Record "SMTP Mail Setup";
            emailCliente: Text;
            body: Text[1000];
            SalesInvoice: Record "Sales Invoice Header";
            creditMemo: Record "Sales Cr.Memo Header";
            CustLedger: Record "Detailed Cust. Ledg. Entry";
            fechaVencimiento: text;
            mystreamXML: InStream;
            InstreamPDF: InStream;
            OutstreamPdf: OutStream;
            tipoCode: TextEncoding;
            xmlTexto: text;
            TempoBlob: Record TempBlob;
            Reporte: report HG_ReporteCFDI;
            ReporteNC: report HG_ReporteCFDI;
            ReportePago: Report HG_ReporteCFDI;
            //Begin Adjustment version 4.0
            Recipients: List of [text];
        //End Adjustment version 4.0
        begin
            if creditMemo.get(invoice) then begin
                if custLedger."Entry No." = 0 then begin
                    mytable.Get(Numcliente);
                    cliente.get(Numcliente);
                    company.get;
                    mailSetup.Get;
                    fechaVencimiento := format(creditMemo."Due Date");
                    emailCliente := mytable.Para;
                    Recipients.Add(emailCliente);
                    body := '';
                    mail.CreateMessage('', mailSetup."User ID", Recipients, mytable.Asunto, body); //New version
                    if mytable.cc <> '' then begin
                        //Begin Adjustment version 4.0
                        Recipients.Add(mytable.Cc);
                        mail.AddRecipients(Recipients);
                        //End Adjustment version 4.0
                        //mail.AddCC(mytable.Cc); for versions 3 or earlier
                    end;
                    if mytable.CCo <> '' then begin
                        //Begin Adjustment version 4.0
                        Recipients.Add(mytable.CCo);
                        mail.AddRecipients(Recipients);
                        //Begin Adjustment version 4.0
                        //mail.AddBCC(mytable.CCo);
                    end;
                    if mytable.Archivo = mytable.Archivo::Ambos then begin

                        myInt := mystreamXML.Read(xmlTexto);
                        if xmlTexto = '' then begin
                            Error('Archivo no enviado, factura no timbrada');
                        end;

                        TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                        TempoBlob.Blob.CreateInStream(InstreamPDF);
                        ReporteNC.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                        mail.AddAttachmentStream(InstreamPDF, 'FacturaNC_' + invoice + '.pdf');

                        mail.AddAttachmentStream(mystreamXML, creditMemo."Bill-to Customer No." + '_' + creditMemo."No." + '.xml');
                    end
                    else
                        if mytable.Archivo = mytable.Archivo::PDF then begin

                            myInt := mystreamXML.Read(xmlTexto);
                            if xmlTexto = '' then begin
                                Error('Archivo no enviado, factura no timbrada');
                            end;

                            TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                            TempoBlob.Blob.CreateInStream(InstreamPDF);
                            ReporteNC.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                            mail.AddAttachmentStream(InstreamPDF, 'FacturaNC_' + invoice + '.pdf');
                        end
                        else
                            if mytable.Archivo = mytable.Archivo::XML then begin

                                mail.AddAttachmentStream(mystreamXML, creditMemo."Bill-to Customer No." + '_' + creditMemo."No." + '.xml');
                            end;
                    if mytable.TipoContenido = mytable.TipoContenido::"Plantilla del cuerpo del correo electrónico del remitente" then begin
                        mail.AppendBody('Factura a N° cliente: ' + cliente."No.");
                        mail.AppendBody('<br>');
                        mail.AppendBody('Factura NC:' + creditMemo."No.");
                        mail.AppendBody('<br><br>');
                        mail.AppendBody('Hola,');
                        mail.AppendBody('<br><br>');
                        mail.AppendBody('Gracias por confiar en nosotros. Documento adjunto a este mensaje.');
                        mail.AppendBody('<br><br>');
                        mail.AppendBody('No. Factura NC: ' + invoice);
                        mail.AppendBody('<br>');
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                        mail.AppendBody('Total: $' + mytable.importe);
                        mail.AppendBody('<br><br>');
                        mail.AppendBody('Un cordial saludo.');
                        mail.AppendBody('<br><br>');
                        mail.AppendBody(company.Name);
                        mail.AppendBody('<br>');
                        mail.AppendBody(company.Address);
                        mail.AppendBody('<br>');
                        mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                    end
                    else begin
                        mail.AppendBody(mytable.Cuerpo);
                        mail.AppendBody('<br><br>');
                        mail.AppendBody('Factura NC: ' + invoice);
                        mail.AppendBody('<br>');
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                        mail.AppendBody('Total: $' + mytable.importe);
                        mail.AppendBody('<br><br>');
                        mail.AppendBody(company.Name);
                        mail.AppendBody('<br>');
                        mail.AppendBody(company.Address);
                        mail.AppendBody('<br>');
                        mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                    end;
                    //Message('%1 %2 %3 %4', mytable.Cc, fechaVencimiento, mytable.importe, mytable.TipoContenido);
                    mail.Send;
                    Message('Se ha enviado el correo electrónico');
                end;
            end;
        end; */

    procedure envioCorreo(Numcliente: Text;
    invoice: text;
    entry: Integer): Boolean
    var
        myInt: Integer;
        mail: Codeunit "SMTP Mail";
        mailSetup: Record "SMTP Mail Setup";
        emailCliente: Text;
        body: Text[1000];
        SalesInvoice: Record "Sales Invoice Header";
        creditMemo: Record "Sales Cr.Memo Header";
        CustLedger: Record "Detailed Cust. Ledg. Entry";
        fechaVencimiento: text;
        mystreamXML: InStream;
        InstreamPDF: InStream;
        OutstreamPdf: OutStream;
        tipoCode: TextEncoding;
        xmlTexto: text;

        TempoBlob: Record TempBlob;
        Reporte: report HG_ReporteCFDI;
        ReporteNC: report HG_ReporteCFDI;
        ReportePago: Report HG_ReporteCFDI;
        //Begin Adjustment version 4.0
        Recipients: List of [text];
    //End Adjustment version 4.0
    begin
        //Complemento Pagos
        Temp.DeleteAll();
        /* if CustLedger.get(entry) then begin
             if (CustLedger."Document Type" = custledger."Document Type"::Payment) and (CustLedger."Entry Type" = CustLedger."Entry Type"::"Initial Entry") then begin
                 mytable.Get(Numcliente);
                 cliente.get(Numcliente);
                 company.get;
                 mailSetup.Get;
                 fechaVencimiento := format(CustLedger."Initial Entry Due Date");
                 emailCliente := mytable.Para;
                 Recipients.Add(emailCliente);
                 body := '';
                 mail.CreateMessage('', mailSetup."User ID", Recipients, mytable.Asunto, body);
                 if mytable.cc <> '' then begin
                     //Begin Adjustment version 4.0
                     Recipients.Add(mytable.Cc);
                     mail.AddRecipients(Recipients);
                 end;
                 if mytable.CCo <> '' then begin
                     Recipients.Add(mytable.CCo);
                     mail.AddRecipients(Recipients);
                 end;
                 if mytable.Archivo = mytable.Archivo::Ambos then begin
                     myInt := mystreamXML.Read(xmlTexto);
                     if xmlTexto = '' then begin
                         Error('Archivo no enviado, pago no timbrado');
                     end;
                     TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                     TempoBlob.Blob.CreateInStream(InstreamPDF);
                     ReportePago.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                     mail.AddAttachmentStream(InstreamPDF, 'FacturaPago_' + invoice + '.pdf');
                     mail.AddAttachmentStream(mystreamXML, CustLedger."Customer No." + '_' + CustLedger."Document No." + '.xml');
                 end
                 else
                     if mytable.Archivo = mytable.Archivo::PDF then begin
                         myInt := mystreamXML.Read(xmlTexto);
                         if xmlTexto = '' then begin
                             Error('Archivo no enviado, factura no timbrada');
                         end;
                         TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                         TempoBlob.Blob.CreateInStream(InstreamPDF);
                         ReportePago.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                         mail.AddAttachmentStream(InstreamPDF, 'FacturaPago_' + invoice + '.pdf');
                     end
                     else
                         if mytable.Archivo = mytable.Archivo::XML then begin
                             clear(TempBlob);
                             TempBlob.Blob.CreateInStream(XMLIStream);
                             FileName := SalesInvoice."No." + '.XML';
                             TempBlob.TryDownloadFromUrl(' http://hgwebapp.azurewebsites.net/api/xml/' + SalesInvoice."No.");
                             mail.AddAttachmentStream(XMLIStream, SalesInvoice."Bill-to Customer No." + '_' + SalesInvoice."No." + '.xml');
                         end;
                 if mytable.TipoContenido = mytable.TipoContenido::"Plantilla del cuerpo del correo electrónico del remitente" then begin
                     mail.AppendBody('Factura a N° cliente: ' + cliente."No.");
                     mail.AppendBody('<br>');
                     mail.AppendBody('Pago facturado:' + CustLedger."Document No.");
                     mail.AppendBody('<br><br>');
                     mail.AppendBody('Hola,');
                     mail.AppendBody('<br><br>');
                     mail.AppendBody('Gracias por confiar en nosotros. Documento adjunto a este mensaje.');
                     mail.AppendBody('<br><br>');
                     mail.AppendBody('No. Pago facturado: ' + invoice);
                     mail.AppendBody('<br>');
                     mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                     mail.AppendBody('<br>');
                     mail.AppendBody('Total: $' + mytable.importe);
                     mail.AppendBody('<br><br>');
                     mail.AppendBody('Un cordial saludo.');
                     mail.AppendBody('<br><br>');
                     mail.AppendBody(company.Name);
                     mail.AppendBody('<br>');
                     mail.AppendBody(company.Address);
                     mail.AppendBody('<br>');
                     mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                 end
                 else begin
                     mail.AppendBody(mytable.Cuerpo);
                     mail.AppendBody('<br><br>');
                     mail.AppendBody('No. Pago facturado: ' + invoice);
                     mail.AppendBody('<br>');
                     mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                     mail.AppendBody('<br>');
                     mail.AppendBody('Total: $' + mytable.importe);
                     mail.AppendBody('<br><br>');
                     mail.AppendBody(company.Name);
                     mail.AppendBody('<br>');
                     mail.AppendBody(company.Address);
                     mail.AppendBody('<br>');
                     mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                 end;
                 //Message('%1 %2 %3 %4', mytable.Cc, fechaVencimiento, mytable.importe, mytable.TipoContenido);
                 mail.Send;
                 Message('Se ha enviado el correo electrónico');
             end
             else begin
                 Error('Seleccione un pago del tipo Initial Entry que esté timbrado');
             end;
         end;*/
        if SalesInvoice.get(invoice) then begin
            if custLedger."Entry No." = 0 then begin
                mytable.Get(Numcliente);
                cliente.get(Numcliente);
                company.get;
                mailSetup.Get;
                fechaVencimiento := format(SalesInvoice."Due Date");
                emailCliente := mytable.Para;
                Recipients.Add(emailCliente);
                body := '';
                mail.CreateMessage('', mailSetup."User ID", Recipients, mytable.Asunto, body);
                if mytable.cc <> '' then begin
                    Recipients.Add(mytable.Cc);
                    mail.AddRecipients(Recipients);
                end;
                if mytable.CCo <> '' then begin
                    Recipients.Add(mytable.CCo);
                    mail.AddRecipients(Recipients);
                end;
                if mytable.Archivo = mytable.Archivo::xmlYpdf then begin
                    /* myInt := mystreamXML.Read(xmlTexto);
                     if xmlTexto = '' then begin
                         Error('Archivo no enviado, factura no timbrada');
                     end;*/
                    nc.SetFilter(nc.Folio, SalesInvoice."No.");
                    temp.Init();
                    temp.getRec := SalesInvoice."No.";
                    temp.Insert();

                    TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                    TempoBlob.Blob.CreateInStream(InstreamPDF);
                    Reporte.SaveAs('', ReportFormat::Pdf, OutstreamPdf);

                    clear(TempBlob);
                    TempBlob.Blob.CreateInStream(XMLIStream);
                    FileName := SalesInvoice."No." + '.XML';

                    if TempBlob.TryDownloadFromUrl(' http://hgwebapp.azurewebsites.net/api/xml/' + SalesInvoice."No.") then begin
                        //DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);

                        mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');
                        mail.AddAttachmentStream(XMLIStream, SalesInvoice."Bill-to Customer No." + '_' + SalesInvoice."No." + '.xml');
                    end else begin
                        Error('Archivo no enviado, factura no timbrada');
                    end;
                end
                else
                    if mytable.Archivo = mytable.Archivo::PDF then begin

                        TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                        TempoBlob.Blob.CreateInStream(InstreamPDF);

                        nc.SetFilter(nc.Folio, SalesInvoice."No.");
                        temp.Init();
                        temp.getRec := SalesInvoice."No.";
                        temp.Insert();

                        Reporte.SaveAs('', ReportFormat::Pdf, OutstreamPdf);

                        mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');

                        //clear(TempBlob);
                        //TempBlob.Blob.CreateInStream(XMLIStream);
                        //FileName := SalesInvoice."No." + '.XML';

                        //TempBlob.TryDownloadFromUrl(' http://hgwebapp.azurewebsites.net/api/xml/' + SalesInvoice."No.");

                        //DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);

                        //mail.AddAttachmentStream(XMLIStream, SalesInvoice."Bill-to Customer No." + '_' + SalesInvoice."No." + '.xml');


                    end;


                if mytable.TipoContenido = mytable.TipoContenido::"Plantilla del cuerpo del correo electrónico del remitente" then begin
                    mail.AppendBody('Factura a N° cliente: ' + cliente."No.");
                    mail.AppendBody('<br>');
                    mail.AppendBody('Factura:' + SalesInvoice."No.");
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Hola,');
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Gracias por confiar en nosotros. Documento adjunto a este mensaje.');
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('No. Factura: ' + invoice);
                    mail.AppendBody('<br>');
                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    /*
                    mail.AppendBody('Un cordial saludo.');
                    mail.AppendBody('<br><br>');
                    mail.AppendBody(company.Name);
                    mail.AppendBody('<br>');
                    mail.AppendBody(company.Address);
                    mail.AppendBody('<br>');
                    mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                    mail.AppendBody('<br>');
                    */
                    mail.AppendBody('<img src="https://i.ibb.co/M1P4SHD/firma.png">');
                end
                else begin
                    mail.AppendBody(mytable.Cuerpo);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Factura: ' + invoice);
                    mail.AppendBody('<br>');
                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    /*
                      mail.AppendBody(company.Name);
                      mail.AppendBody('<br>');
                      mail.AppendBody(company.Address);
                      mail.AppendBody('<br>');
                      mail.AppendBody(company."Post Code" + ' ' + company.City + ', ' + company.County);
                      mail.AppendBody('<br>');
                    */
                    mail.AppendBody('<img src="https://i.ibb.co/M1P4SHD/firma.png">');
                end;
                //Message('%1 %2 %3 %4', mytable.Cc, fechaVencimiento, mytable.importe, mytable.TipoContenido);
                mail.Send;
                Message('Se ha enviado el correo electrónico');
            end;
        end;
    end;

    var
        myInt: Integer;
        mypage: Page "EnviarCorreoPage";
        cliente: Record Customer;
        mytable: Record EnviarCorreoTable;
        company: Record "Company Information";
        temp: Record temporal;
        nc: Record NCTimbradas;

        ImportXmlFile: File;
        XmlINStream: InStream;

        XMLIStream: InStream;
        FileName: Text;
        TempBlob: Record TempBlob temporary;

}
