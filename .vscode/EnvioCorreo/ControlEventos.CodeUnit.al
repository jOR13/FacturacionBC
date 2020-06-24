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
        mytable.tipo := 'fac';
        mytable.Insert(true);
        Commit();
        mypage.Run();
    end;


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
        mytable.Archivo := mytable.Archivo::xmlYpdf;
        mytable.importe := Format(NotaCredito."Amount Including VAT", 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
        mytable.tipo := 'nc';
        mytable.Insert(true);
        Commit();
        mypage.Run();
    end;

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
    //ENVIO DE NC
    procedure envioCorreoNC(Numcliente: Text;
    invoice: text): Boolean
    begin
        Temp.DeleteAll();
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
                mail.CreateMessage('', mailSetup."User ID", Recipients, mytable.Asunto, body);
                if mytable.cc <> '' then begin
                    copias := mytable.Cc.Split(';');
                    foreach copiaItem in copias do begin
                        Recipients.Add(copiaItem);
                    end;
                    mail.AddRecipients(Recipients);
                end;
                if mytable.CCo <> '' then begin
                    Recipients.Add(mytable.CCo);
                    mail.AddRecipients(Recipients);
                end;
                if mytable.Archivo = mytable.Archivo::xmlYpdf then begin
                    nc.SetFilter(nc.Folio, creditMemo."No.");
                    temp.Init();
                    temp.getRec := creditMemo."No.";
                    temp.Insert();
                    TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                    TempoBlob.Blob.CreateInStream(InstreamPDF);
                    ReporteNC.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                    clear(TempBlob);
                    TempBlob.Blob.CreateInStream(XMLIStream);
                    FileName := creditMemo."No." + '.XML';
                    if TempBlob.TryDownloadFromUrl('http://hgwebapp.azurewebsites.net/api/xml/' + creditMemo."No.") then begin
                        mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');
                        mail.AddAttachmentStream(XMLIStream, creditMemo."Bill-to Customer No." + '_' + creditMemo."No." + '.xml');
                    end else begin
                        Error('Archivo no enviado, factura no timbrada');
                    end;
                end
                else
                    if mytable.Archivo = mytable.Archivo::XML then begin
                        clear(TempBlob);
                        TempBlob.Blob.CreateInStream(XMLIStream);
                        FileName := creditMemo."No." + '.XML';
                        TempBlob.TryDownloadFromUrl(' http://hgwebapp.azurewebsites.net/api/xml/' + creditMemo."No.");
                        DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);
                        mail.AddAttachmentStream(XMLIStream, creditMemo."Bill-to Customer No." + '_' + creditMemo."No." + '.xml');
                    end;
                if mytable.Archivo = mytable.Archivo::PDF then begin
                    TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                    TempoBlob.Blob.CreateInStream(InstreamPDF);
                    nc.SetFilter(nc.Folio, creditMemo."No.");
                    temp.Init();
                    temp.getRec := creditMemo."No.";
                    temp.Insert();
                    Reporte.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                    mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');
                end;
                if mytable.TipoContenido = mytable.TipoContenido::"Plantilla del cuerpo del correo electrónico del remitente" then begin
                    mail.AppendBody('Factura a N° cliente: ' + cliente."No.");
                    mail.AppendBody('<br>');
                    mail.AppendBody('Factura:' + creditMemo."No.");
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Hola,');
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Gracias por confiar en nosotros. Documento adjunto a este mensaje.');
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('No. Factura: ' + invoice);
                    mail.AppendBody('<br>');
                    if SalesInvoice."Payment Method Code" <> '0' then begin
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                    end;
                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('<img src="https://i.ibb.co/zXzmF9G/firmaF.png">');
                end
                else begin
                    mail.AppendBody(mytable.Cuerpo);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Factura: ' + invoice);
                    mail.AppendBody('<br>');
                    if SalesInvoice."Payment Method Code" <> '0' then begin
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                    end;
                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('<img src="https://i.ibb.co/zXzmF9G/firmaF.png">');
                end;
                mail.Send;
                Message('Se ha enviado el correo electrónico');
            end;
        end;
    end;


    //ENVIO DE FACTURAS
    procedure envioCorreo(Numcliente: Text;
    invoice: text;
    entry: Integer): Boolean
    var

    begin
        Temp.DeleteAll();
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
                    copias := mytable.Cc.Split(';');
                    foreach copiaItem in copias do begin
                        Recipients.Add(copiaItem);
                    end;
                    mail.AddRecipients(Recipients);
                end;
                if mytable.CCo <> '' then begin
                    Recipients.Add(mytable.CCo);
                    mail.AddRecipients(Recipients);
                end;
                if mytable.Archivo = mytable.Archivo::xmlYpdf then begin
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
                    if TempBlob.TryDownloadFromUrl('http://hgwebapp.azurewebsites.net/api/xml/' + SalesInvoice."No.") then begin
                        mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');
                        mail.AddAttachmentStream(XMLIStream, SalesInvoice."Bill-to Customer No." + '_' + SalesInvoice."No." + '.xml');
                    end else begin
                        Error('Archivo no enviado, factura no timbrada');
                    end;
                end
                else
                    if mytable.Archivo = mytable.Archivo::XML then begin
                        clear(TempBlob);
                        TempBlob.Blob.CreateInStream(XMLIStream);
                        FileName := SalesInvoice."No." + '.XML';
                        TempBlob.TryDownloadFromUrl(' http://hgwebapp.azurewebsites.net/api/xml/' + SalesInvoice."No.");
                        DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);
                        mail.AddAttachmentStream(XMLIStream, SalesInvoice."Bill-to Customer No." + '_' + SalesInvoice."No." + '.xml');
                    end;
                if mytable.Archivo = mytable.Archivo::PDF then begin
                    TempoBlob.Blob.CreateOutStream(OutstreamPdf);
                    TempoBlob.Blob.CreateInStream(InstreamPDF);
                    nc.SetFilter(nc.Folio, SalesInvoice."No.");
                    temp.Init();
                    temp.getRec := SalesInvoice."No.";
                    temp.Insert();
                    Reporte.SaveAs('', ReportFormat::Pdf, OutstreamPdf);
                    mail.AddAttachmentStream(InstreamPDF, 'Factura_' + invoice + '.pdf');
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

                    if SalesInvoice."Payment Method Code" <> '0' then begin
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                    end;

                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('<img src="https://i.ibb.co/zXzmF9G/firmaF.png">');
                end
                else begin
                    mail.AppendBody(mytable.Cuerpo);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('Factura: ' + invoice);
                    mail.AppendBody('<br>');

                    if SalesInvoice."Payment Method Code" <> '0' then begin
                        mail.AppendBody('Fecha de vencimiento: ' + fechaVencimiento);
                        mail.AppendBody('<br>');
                    end;

                    mail.AppendBody('Total: $' + mytable.importe);
                    mail.AppendBody('<br><br>');
                    mail.AppendBody('<img src="https://i.ibb.co/zXzmF9G/firmaF.png">');
                end;
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
        copias: List of [Text];
        copiaItem: Text[250];
        XMLIStream: InStream;
        FileName: Text;
        TempBlob: Record TempBlob temporary;

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
        ReporteNC: report HG_NotaDeCredito;
        ReportePago: Report HG_ReporteCFDI;
        //Begin Adjustment version 4.0
        Recipients: List of [text];

}
