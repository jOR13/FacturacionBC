codeunit 50956 UploadXML
{
    procedure ReadXML(xmlTexto: Text)
    var
        myInt: Integer;
        xmlDoc: XmlDocument;
        read: boolean;
        node: XmlNode;
        nodeTax: XmlNode;
        nodeList: XmlNodeList;
        nodeTaxList: XmlNodeList;
        cursorTax: Integer;
        totalCursorTax: Integer;
        nodeListAduana: XmlNodeList;
        nodeListInfoAduana: XmlNodeList;
        nodeAduana: XmlNode;
        cursorInfoAduana: Integer;
        totalCurInfoAduana: Integer;
        nsm: XmlNamespaceManager;
        txt: xmlAttribute;
        reportable: Record facturas_Timbradas;
        ReportLines: record ReportLinesTableHG;
        cust: Record Customer;
        grantexto: Text;
        substring1: Text;
        substring2: text;
        cadenaOriginal1: text;
        cadenaoriginal2: text;
        cursor: Integer;
        totalCursor: Integer;
        sumaImpuestos: Decimal;
        Subtotal: Decimal;
        ImpTras: Decimal;
        importeIeps: Decimal;
        SumaIepsSubtotal: Decimal;
        SumaIeps: Decimal;
        SumaIepsImpTras: Decimal;
        SumaTaxLineAmount: Decimal;
        SumBaseLineAmount: Decimal;
        SumaBase: Decimal;
        SumaIva: Decimal;
        iepsTxt: text;
        TipoImpuesto: text;
        pedimentosTable: Record PedimentosTableHG;
        pedimentoReportTable: Record PedimentosReportTableHG;
        salesInvoiceHeader: Record "Sales Invoice Header";
        salesInvoiceLine: Record "Sales Invoice Line";
        NumFactura: Code[20];
        NumOrder: Code[20];
        cr: Char;
        lf: Char;
        formato: Decimal;
        //
        LineAmount: Decimal;
        LineQty: Decimal;
        LineUnitValue: Decimal;
    //
    begin
        SumBaseLineAmount := 0;
        SumaBase := 0;
        cr := 13;
        lf := 10;
        //cust.get(cliente);
        //reportable.DeleteAll();
        //ReportLines.DeleteAll();
        pedimentoReportTable.DeleteAll();
        read := XmlDocument.ReadFrom(xmlTexto, xmlDoc);
        nsm.NameTable(xmlDoc.NameTable());
        //Start Name Spaces//        
        nsm.AddNamespace('x', 'http://www.sat.gob.mx/cfd/3');
        nsm.AddNamespace('tfd', 'http://www.sat.gob.mx/TimbreFiscalDigital');


        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Fecha', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.Fecha := txt.Value();
        //FormaDePago//start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@MetodoPago', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'PPD' then
            reportable."Metodo de pago" := txt.Value() + '- Pago en parcialidades o diferido'
        else
            reportable."Metodo de pago" := txt.Value() + '- Pago en una sola exhibición';
        //FormaDePago//end
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@FormaPago', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '01':
                begin
                    reportable.FormaDePago := ' 01 - Efectivo';
                end;
            '02':
                begin
                    reportable.FormaDePago := '02 - Cheque nominativo';
                end;
            '03':
                begin
                    reportable.FormaDePago := '03 - Transferencia electrónica de fondos';
                end;
            '04':
                begin
                    reportable.FormaDePago := '04 - Tarjeta de crédito';
                end;
            '05':
                begin
                    reportable.FormaDePago := '05 - Monedero electrónico';
                end;
            '06':
                begin
                    reportable.FormaDePago := '06 - Dinero electrónico';
                end;
            '08':
                begin
                    reportable.FormaDePago := '08 - Vales de despensa';
                end;
            '12':
                begin
                    reportable.FormaDePago := '12 - Dación en pago';
                end;
            '13':
                begin
                    reportable.FormaDePago := '13 - Pago por subrogación';
                end;
            '14':
                begin
                    reportable.FormaDePago := '14 - Pago por consignación';
                end;
            '15':
                begin
                    reportable.FormaDePago := '15 - Condonación';
                end;
            '23':
                begin
                    reportable.FormaDePago := '23 - Novación';
                end;
            '24':
                begin
                    reportable.FormaDePago := '24 - Confusión';
                end;
            '25':
                begin
                    reportable.FormaDePago := '25 - Remisión de deuda';
                end;
            '26':
                begin
                    reportable.FormaDePago := '26 - Prescripción o caducidad';
                end;
            '27':
                begin
                    reportable.FormaDePago := '27 - A satisfacción del acreedor';
                end;
            '28':
                begin
                    reportable.FormaDePago := '28 - Tarjeta de débito';
                end;
            '29':
                begin
                    reportable.FormaDePago := '29 - Tarjeta de servicios';
                end;
            '30':
                begin
                    reportable.FormaDePago := '30 - Aplicación de anticipos';
                end;
            '31':
                begin
                    reportable.FormaDePago := '31 - Intermediario pagos';
                end;
            '99':
                begin
                    reportable.FormaDePago := '99 - Por definir';
                end;
        end;
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@TipoCambio', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.TipoCambio := txt.Value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Moneda', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'MXN' then
            reportable.Moneda := txt.Value() + ' Peso Mexicano'
        else
            reportable.Moneda := txt.Value() + ' Dolar Americano';
        moneda := reportable.Moneda;
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Folio', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.Folio := txt.Value();
        NumFactura := txt.Value();
        /*
        salesInvoiceHeader.SetCurrentKey("No.");
        salesInvoiceHeader.SetRange("No.", reportable.Folio);
        if salesInvoiceHeader.Find('-') then begin
            NumOrder := salesInvoiceHeader."Order No.";
            reportable. := NumOrder;
        end;*/

        //Numero de Pedimentos/// 
        /*
        pedimentosTable.SetCurrentKey(DocumentNo);
        pedimentosTable.SetRange(DocumentNo, NumOrder);
        cursorInfoAduana := 1;
        if pedimentosTable.FindSet() then begin
            repeat //totalCursor := pedimentosTable.Count(); 
                pedimentoReportTable.Pedimento := pedimentosTable.Pedimento;
                pedimentoReportTable.FechaPedTxt := pedimentosTable.FechaTxt;
                pedimentoReportTable.index := cursorInfoAduana;
                cursorInfoAduana := cursorInfoAduana + 1;
                pedimentoReportTable.Insert();
                Commit();
            until (pedimentosTable.Next = 0)
        end;*/
        /////
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@SubTotal', nsm, node);
        txt := node.AsXmlAttribute();
        read := Evaluate(Subtotal, txt.Value());
        //Message('Suma de Subtotal %1', subtotal + subtotal);

        Evaluate(reportable.SubTotal, txt.value());

        //TipoComprobante//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@TipoDeComprobante', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'I' then
            reportable.tipoDeComprobante := 'I - Ingreso'
        else
            reportable.tipoDeComprobante := 'E - Egreso';
        //TipoComprobante//End
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@LugarExpedicion', nsm, node);
        txt := node.AsXmlAttribute();
        reportable."Lugar de expedición" := txt.value();
        //Total y Amount in Words
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Total', nsm, node);
        txt := node.AsXmlAttribute();
        read := Evaluate(formato, txt.Value());
        Evaluate(reportable.Total, Format(formato, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>'));
        montoGlobal := txt.Value();
        MakeRequest();
        reportable.CantidadLetra := numUnidades;
        //
        //Emisor//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Emisor/@Rfc', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.RFC := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Emisor/@RegimenFiscal', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '601':
                begin
                    reportable."Regimen Fiscal" := '601 - General de Ley Personas Morales';
                end;
            '603':
                begin
                    reportable."Regimen Fiscal" := '603 - Personas Morales con Fines no Lucrativos';
                end;
            '605':
                begin
                    reportable."Regimen Fiscal" := '605 - Sueldos y Salarios e Ingresos Asimilados a Salarios';
                end;
            '606':
                begin
                    reportable."Regimen Fiscal" := '606 - Arrendamiento';
                end;
            '608':
                begin
                    reportable."Regimen Fiscal" := '608 - Demás ingresos';
                end;
            '609':
                begin
                    reportable."Regimen Fiscal" := '609 - Consolidación';
                end;
            '610':
                begin
                    reportable."Regimen Fiscal" := '610 - Residentes en el Extranjero sin Establecimiento Permanente en México';
                end;
            '611':
                begin
                    reportable."Regimen Fiscal" := '611 - Ingresos por Dividendos (socios y accionistas)';
                end;
            '612':
                begin
                    reportable."Regimen Fiscal" := '612 - Personas Físicas con Actividades Empresariales y Profesionales';
                end;
            '614':
                begin
                    reportable."Regimen Fiscal" := '614 - Ingresos por intereses';
                end;
            '616':
                begin
                    reportable."Regimen Fiscal" := '616 - Sin obligaciones fiscales';
                end;
            '620':
                begin
                    reportable."Regimen Fiscal" := '620 - Sociedades Cooperativas de Producción que optan por diferir sus ingresos';
                end;
            '621':
                begin
                    reportable."Regimen Fiscal" := '621 - Incorporación Fiscal';
                end;
            '622':
                begin
                    reportable."Regimen Fiscal" := '622 - Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras';
                end;
            '623':
                begin
                    reportable."Regimen Fiscal" := '623 - Opcional para Grupos de Sociedades';
                end;
            '624':
                begin
                    reportable."Regimen Fiscal" := '624 - Coordinados';
                end;
            '628':
                begin
                    reportable."Regimen Fiscal" := '628 - Hidrocarburos';
                end;
            '607':
                begin
                    reportable."Regimen Fiscal" := '607 - Régimen de Enajenación o Adquisición de Bienes';
                end;
            '629':
                begin
                    reportable."Regimen Fiscal" := '629 - De los Regímenes Fiscales Preferentes y de las Empresas Multinacionales';
                end;
            '630':
                begin
                    reportable."Regimen Fiscal" := '630 - Enajenación de acciones en bolsa de valores';
                end;
            '615':
                begin
                    reportable."Regimen Fiscal" := '615 - Régimen de los ingresos por obtención de premios';
                end;
        end;
        //Emisor//End
        //Receptor//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@Nombre', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.NombreReceptor := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@Rfc', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.RfcReceptor := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@UsoCFDI', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            'G01':
                begin
                    reportable.UsoCFDI := 'G01 - Adquisición de mercancias';
                end;
            'G02':
                begin
                    reportable.UsoCFDI := 'G02 - Devoluciones, descuentos o bonificaciones';
                end;
            'G03':
                begin
                    reportable.UsoCFDI := 'G03 - Gastos en general';
                end;
            'I01':
                begin
                    reportable.UsoCFDI := 'I01 - Construcciones';
                end;
            'I02':
                begin
                    reportable.UsoCFDI := 'I02 - Mobilario y equipo de oficina por inversiones';
                end;
            'I03':
                begin
                    reportable.UsoCFDI := 'I03 - Equipo de transporte';
                end;
            'I04':
                begin
                    reportable.UsoCFDI := 'I04 - Equipo de computo y accesorios';
                end;
            'I05':
                begin
                    reportable.UsoCFDI := 'I05 - Dados, troqueles, moldes, matrices y herramental';
                end;
            'I06':
                begin
                    reportable.UsoCFDI := 'I06 - Comunicaciones telefónicas';
                end;
            'I07':
                begin
                    reportable.UsoCFDI := 'I07 - Comunicaciones satelitales';
                end;
            'I08':
                begin
                    reportable.UsoCFDI := 'I08 - Otra maquinaria y equipo';
                end;
            'D01':
                begin
                    reportable.UsoCFDI := 'D01 - Honorarios médicos, dentales y gastos hospitalarios.';
                end;
            'D02':
                begin
                    reportable.UsoCFDI := 'D02 - Gastos médicos por incapacidad o discapacidad';
                end;
            'D03':
                begin
                    reportable.UsoCFDI := 'D03 - Gastos funerales.';
                end;
            'D04':
                begin
                    reportable.UsoCFDI := 'D04 - Donativos.';
                end;
            'D05':
                begin
                    reportable.UsoCFDI := 'D05 - Intereses reales efectivamente pagados por créditos hipotecarios (casa habitación).';
                end;
            'D06':
                begin
                    reportable.UsoCFDI := 'D06 - Aportaciones voluntarias al SAR.';
                end;
            'D07':
                begin
                    reportable.UsoCFDI := 'D07 - Primas por seguros de gastos médicos.';
                end;
            'D08':
                begin
                    reportable.UsoCFDI := 'D08 - Gastos de transportación escolar obligatoria.';
                end;
            'D09':
                begin
                    reportable.UsoCFDI := 'D09 - Depósitos en cuentas para el ahorro, primas que tengan como base planes de pensiones.';
                end;
            'D10':
                begin
                    reportable.UsoCFDI := 'D10 - Pagos por servicios educativos (colegiaturas)';
                end;
            'P01':
                begin
                    reportable.UsoCFDI := 'P01 - Por definir';
                end;
        end;
        //Receptor//End
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Impuestos/@TotalImpuestosTrasladados', nsm, node);
        txt := node.AsXmlAttribute();
        if read then begin
            read := Evaluate(ImpTras, txt.Value());
            Evaluate(reportable.IVA, txt.Value());

        end;
        //Footer//Start 
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@UUID', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.UUID := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@FechaTimbrado', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.FechaTimbrado := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@NoCertificado', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.NoCertificado := txt.Value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@NoCertificadoSAT', nsm, node);
        txt := node.AsXmlAttribute();
        reportable.NoCertificadoSAT := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@SelloCFD', nsm, node);
        txt := node.AsXmlAttribute();
        grantexto := txt.value();
        substring1 := grantexto.Substring(1, 250);
        reportable.SelloDigitalCFD := substring1;
        substring2 := grantexto.Substring(251);
        reportable.SelloDigitalCFD := substring2;
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@SelloSAT', nsm, node);
        txt := node.AsXmlAttribute();
        grantexto := txt.value();
        substring1 := grantexto.Substring(1, 250);
        reportable.SelloSAT := substring1;
        substring2 := grantexto.Substring(251);
        reportable.SelloSAT := substring2;
        //Footer//End
        //Cadena Original
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@Version', nsm, node);
        txt := node.AsXmlAttribute();
        cadenaOriginal1 += '|' + txt.Value() + '|';
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@UUID', nsm, node);
        txt := node.AsXmlAttribute();
        cadenaOriginal1 += txt.Value() + '|';
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@FechaTimbrado', nsm, node);
        txt := node.AsXmlAttribute();
        cadenaOriginal1 += txt.Value() + '|';
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@SelloCFD', nsm, node);
        txt := node.AsXmlAttribute();
        cadenaOriginal1 += txt.Value() + '|';
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@NoCertificadoSAT', nsm, node);
        txt := node.AsXmlAttribute();
        cadenaOriginal1 += txt.Value();
        substring1 := cadenaOriginal1.Substring(1, 250);
        reportable.CertificadoCadena := substring1;
        substring2 := cadenaOriginal1.Substring(251);
        reportable.CertificadoCadenaPart2 := substring2;
        //CadenaOriginal End
        //"Tipo relacion" Notas de Crédito
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:CfdiRelacionados/@TipoRelacion', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '01':
                begin
                    reportable."Tipo relacion" := '01 - Nota de crédito de los documentos relacionados';
                end;
            '02':
                begin
                    reportable."Tipo relacion" := '02 - Nota de débito de los documentos relacionados';
                end;
            '03':
                begin
                    reportable."Tipo relacion" := '03 - Devolución de mercancía sobre facturas o traslados previos';
                end;
            '04':
                begin
                    reportable."Tipo relacion" := '04 - Sustitución de los CFDI previos';
                end;
            '05':
                begin
                    reportable."Tipo relacion" := '05 - Traslados de mercancias facturados previamente';
                end;
            '06':
                begin
                    reportable."Tipo relacion" := '06 - Factura generada por los traslados previos';
                end;
            '07':
                begin
                    reportable."Tipo relacion" := '07 - CFDI por aplicación de anticipo';
                end;
            '08':
                begin
                    reportable."Tipo relacion" := '08 - Factura generada por pagos en parcialidades';
                end;
            '09':
                begin
                    reportable."Tipo relacion" := '09 - Factura generada por pagos diferidos';
                end;
            else
        // reportable."Tipo relacion" := salesInvoiceHeader.RelationType;
        end;
        //Tipo de relación End
        //UUID Relacionados
        read := xmlDoc.SelectNodes('/x:Comprobante/x:CfdiRelacionados/x:CfdiRelacionado', nsm, nodeList);
        cursor := 1;
        totalCursor := nodeList.Count();
        while (cursor <= totalCursor) do begin
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@UUID', nsm, node);
            txt := node.AsXmlAttribute();
            reportable."UUID Relacionado" += txt.Value() + FORMAT(CR, 0, '<CHAR>') + FORMAT(LF, 0, '<CHAR>');
            cursor := cursor + 1;
        end;
        //UUID Relacionados End
        //UUID Folio Relacionado
        if reportable."UUID Relacionado" <> '' then begin
            reportable."UUID Relacionado" := reportable."UUID Relacionado";
        end
        else begin
            //  reportable.FolioRelacionado := '';
        end;
        //UUID Folio Relacionado End
        //Lineas//Start
        read := xmlDoc.SelectNodes('/x:Comprobante/x:Conceptos/x:Concepto', nsm, nodeList);
        cursor := 1;
        totalCursor := nodeList.Count();
        while (cursor <= totalCursor) do begin
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ClaveProdServ', nsm, node);
            txt := node.AsXmlAttribute();
            ReportLines.ClaveProducto := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ClaveUnidad', nsm, node);
            txt := node.AsXmlAttribute();
            ReportLines.ClaveUnidad := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Cantidad', nsm, node);
            txt := node.AsXmlAttribute();
            ReportLines.Qty := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Descripcion', nsm, node);
            txt := node.AsXmlAttribute();
            ReportLines.Description := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ValorUnitario', nsm, node);
            txt := node.AsXmlAttribute();
            read := Evaluate(formato, txt.Value());
            ReportLines.UnitValue := Format(formato, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Importe', nsm, node);
            txt := node.AsXmlAttribute();
            read := Evaluate(formato, txt.Value());
            ReportLines.Amount := Format(formato, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
            ;
            ReportLines.Discount := salesInvoiceHeader."Invoice Discount Amount";
            read := nodeList.Get(cursor, node);
            read := node.SelectNodes('/x:Comprobante/x:Conceptos/x:Concepto/x:Impuestos/x:Traslados/x:Traslado', nsm, nodeTaxList);
            cursorTax := 1;
            totalCursorTax := nodeTaxList.Count();
            while (cursorTax <= totalCursorTax) do begin
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@TipoFactor', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                ReportLines.TipoFactor := txt.Value();
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@TasaOCuota', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                read := Evaluate(formato, txt.Value());
                ReportLines.TasaOCuota := Format((formato * 100), 0, '<precision, 4:4><standard format,0>%');
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@Impuesto', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                TipoImpuesto := txt.Value();
                if TipoImpuesto = '002' then begin
                    ReportLines.Impuesto := 'IVA';
                    ReportLines.Tipo := 'Traslado';
                    read := nodeTaxList.Get(cursorTax, nodeTax);
                    read := nodeTax.SelectSingleNode('@Base', nsm, nodeTax);
                    txt := nodeTax.AsXmlAttribute();
                    read := Evaluate(SumaBase, txt.Value());
                    SumBaseLineAmount += SumaBase;
                    //ReportLines.Base1 := txt.Value();
                    read := nodeTaxList.Get(cursorTax, nodeTax);
                    read := nodeTax.SelectSingleNode('@Importe', nsm, nodeTax);
                    txt := nodeTax.AsXmlAttribute();
                    read := Evaluate(SumaIva, txt.Value());
                    SumaTaxLineAmount += SumaIva;
                    //reportLines.TaxLineAmount := txt.Value();                  
                end;
                if TipoImpuesto = '003' then begin
                    read := nodeTaxList.Get(cursorTax, nodeTax);
                    read := nodeTax.SelectSingleNode('@Importe', nsm, nodeTax);
                    txt := nodeTax.AsXmlAttribute();
                    read := Evaluate(importeIeps, txt.Value());
                    SumaIeps += importeIeps;
                end;
                cursorTax := cursorTax + 1;
            end;
            ReportLines.Base1 := Format(SumBaseLineAmount, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>');
            ReportLines.TaxLineAmount := Format(SumaTaxLineAmount, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
            if SumaIeps > 0 then begin
                read := Evaluate(LineAmount, ReportLines.Amount);
                LineAmount += SumaIeps;
                ReportLines.Amount := Format(LineAmount, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
                read := Evaluate(LineQty, ReportLines.qty);
                LineUnitValue := LineAmount / LineQty;
                ReportLines.UnitValue := Format(LineUnitValue, 0, '<Sign><Integer Thousand><Decimals><Comma,.>');
                Subtotal += SumaIeps;
                ImpTras -= SumaIeps;
            end;
            ReportLines.Index := cursor;
            cursor := cursor + 1;
            ReportLines.Insert();
            Commit();
        end;
        /*
        reportable."QR String" := '?re=' + reportable.RFC + '&rr=' + reportable.RfcReceptor + '&tt=' + reportable.Total + '&id=' + reportable.UUID;
        reportable.IVA := Format(ImpTras, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>');
        reportable.SubTotal := Format(Subtotal, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>');*/
        //Lineas//End
        Reportable.Insert();
        Commit();
    end;


    procedure MakeRequest() responseText: Text;
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        BaseURL: Text;
        requestText: Text;
    begin
        // Add the payload to the content
        BaseURL := 'https://mit-signature-generator.azurewebsites.net/amount';
        requestText := StrSubstNo('{"client":"$taff009","amount":%1,"currency":"%2"}', montoGlobal, moneda);
        // Retrieve the contentHeaders associated with the content
        content.WriteFrom(requestText);
        content.GetHeaders(contentHeaders); //quit
                                            //contentHeaders.Clear();//add
        contentHeaders.Remove('Content-Type');
        contentHeaders.Add('Content-Type', 'application/json');
        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message
        request.Content := content; //add
        request.SetRequestUri(BaseURL);
        request.Method := 'POST';
        request.Content().ReadAs(requestText); ///////
        client.Send(request, response);
        // Read the response content as json.
        response.Content().ReadAs(responseText);
        if response.HttpStatusCode = 200 then begin
            numUnidades := responseText;
        end
        else begin
            numUnidades := '';
        end;
    end;


    var
        numUnidades: text;
        unidadesDecena: Text;
        unidadDec: Integer;
        httpCliente: HttpClient;
        ResponseMessage: HttpResponseMessage;
        montoGlobal: Text;
        moneda: Text;
        bool: Boolean;
}