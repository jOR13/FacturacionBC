codeunit 50956 UploadXML
{
    procedure ReadXML(xmlTexto: Text) responseText: Text;

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
        ft: Record facturas_Timbradas;
        ftc: record Conceptos;
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
        DescuentoTotal: Decimal;
        //pedimentosTable: Record PedimentosTableHG;
        //pedimentoReportTable: Record PedimentosReportTableHG;
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
        //ft.DeleteAll();
        //ftc.DeleteAll();
        //pedimentoReportTable.DeleteAll();
        read := XmlDocument.ReadFrom(xmlTexto, xmlDoc);
        nsm.NameTable(xmlDoc.NameTable());
        //Start Name Spaces//        
        nsm.AddNamespace('x', 'http://www.sat.gob.mx/cfd/3');
        nsm.AddNamespace('tfd', 'http://www.sat.gob.mx/TimbreFiscalDigital');

        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Fecha', nsm, node);
        txt := node.AsXmlAttribute();
        Evaluate(ft.Fecha, txt.Value());

        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Descuento', nsm, node);
        if read = true then begin
            txt := node.AsXmlAttribute();
            Evaluate(ft.DescuentoTotal, txt.Value());
        end else
            ft.DescuentoTotal := 0;

        //FormaDePago//start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@MetodoPago', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'PPD' then
            ft."Metodo de pago" := txt.Value() + '- Pago en parcialidades o diferido'
        else
            ft."Metodo de pago" := txt.Value() + '- Pago en una sola exhibición';
        //FormaDePago//end
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@FormaPago', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '01':
                begin
                    ft.FormaDePago := ' 01 - Efectivo';
                end;
            '02':
                begin
                    ft.FormaDePago := '02 - Cheque nominativo';
                end;
            '03':
                begin
                    ft.FormaDePago := '03 - Transferencia electrónica de fondos';
                end;
            '04':
                begin
                    ft.FormaDePago := '04 - Tarjeta de crédito';
                end;
            '05':
                begin
                    ft.FormaDePago := '05 - Monedero electrónico';
                end;
            '06':
                begin
                    ft.FormaDePago := '06 - Dinero electrónico';
                end;
            '08':
                begin
                    ft.FormaDePago := '08 - Vales de despensa';
                end;
            '12':
                begin
                    ft.FormaDePago := '12 - Dación en pago';
                end;
            '13':
                begin
                    ft.FormaDePago := '13 - Pago por subrogación';
                end;
            '14':
                begin
                    ft.FormaDePago := '14 - Pago por consignación';
                end;
            '15':
                begin
                    ft.FormaDePago := '15 - Condonación';
                end;
            '23':
                begin
                    ft.FormaDePago := '23 - Novación';
                end;
            '24':
                begin
                    ft.FormaDePago := '24 - Confusión';
                end;
            '25':
                begin
                    ft.FormaDePago := '25 - Remisión de deuda';
                end;
            '26':
                begin
                    ft.FormaDePago := '26 - Prescripción o caducidad';
                end;
            '27':
                begin
                    ft.FormaDePago := '27 - A satisfacción del acreedor';
                end;
            '28':
                begin
                    ft.FormaDePago := '28 - Tarjeta de débito';
                end;
            '29':
                begin
                    ft.FormaDePago := '29 - Tarjeta de servicios';
                end;
            '30':
                begin
                    ft.FormaDePago := '30 - Aplicación de anticipos';
                end;
            '31':
                begin
                    ft.FormaDePago := '31 - Intermediario pagos';
                end;
            '99':
                begin
                    ft.FormaDePago := '99 - Por definir';
                end;
        end;

        // read := xmlDoc.SelectSingleNode('/x:Comprobante/@TipoCambio', nsm, node);
        //txt := node.AsXmlAttribute();
        ft.TipoCambio := '';

        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Moneda', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'MXN' then
            ft.Moneda := txt.Value() + ' Peso Mexicano'
        else
            ft.Moneda := txt.Value() + ' Dolar Americano';
        moneda := ft.Moneda;
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Folio', nsm, node);
        txt := node.AsXmlAttribute();
        ft.Folio := txt.Value();
        ftc.Folio := ft.Folio;
        responseText := ft.folio;
        NumFactura := txt.Value();

        read := xmlDoc.SelectSingleNode('/x:Comprobante/@SubTotal', nsm, node);
        txt := node.AsXmlAttribute();
        read := Evaluate(Subtotal, txt.Value());
        //Message('Suma de Subtotal %1', subtotal + subtotal);

        Evaluate(ft.SubTotal, txt.value());

        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@RfcProvCertif', nsm, node);
        txt := node.AsXmlAttribute();
        ft."RFC provedor" := txt.Value;


        //TipoComprobante//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@TipoDeComprobante', nsm, node);
        txt := node.AsXmlAttribute();
        if txt.Value() = 'I' then
            ft.tipoDeComprobante := 'I - Ingreso'
        else
            ft.tipoDeComprobante := 'E - Egreso';
        //TipoComprobante//End
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@LugarExpedicion', nsm, node);
        txt := node.AsXmlAttribute();
        ft."Lugar de expedición" := txt.value();
        //Total y Amount in Words
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@Total', nsm, node);
        txt := node.AsXmlAttribute();
        read := Evaluate(formato, txt.Value());
        Evaluate(ft.Total, Format(formato/*, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>')*/));
        ft.TotalText := txt.Value();
        // cod.MakeRequest(ft.Total);
        //ft.CantidadLetra := numUnidades;
        //
        //Emisor//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Emisor/@Rfc', nsm, node);
        txt := node.AsXmlAttribute();
        ft.RFC := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Emisor/@RegimenFiscal', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '601':
                begin
                    ft."Regimen Fiscal" := '601 - General de Ley Personas Morales';
                end;
            '603':
                begin
                    ft."Regimen Fiscal" := '603 - Personas Morales con Fines no Lucrativos';
                end;
            '605':
                begin
                    ft."Regimen Fiscal" := '605 - Sueldos y Salarios e Ingresos Asimilados a Salarios';
                end;
            '606':
                begin
                    ft."Regimen Fiscal" := '606 - Arrendamiento';
                end;
            '608':
                begin
                    ft."Regimen Fiscal" := '608 - Demás ingresos';
                end;
            '609':
                begin
                    ft."Regimen Fiscal" := '609 - Consolidación';
                end;
            '610':
                begin
                    ft."Regimen Fiscal" := '610 - Residentes en el Extranjero sin Establecimiento Permanente en México';
                end;
            '611':
                begin
                    ft."Regimen Fiscal" := '611 - Ingresos por Dividendos (socios y accionistas)';
                end;
            '612':
                begin
                    ft."Regimen Fiscal" := '612 - Personas Físicas con Actividades Empresariales y Profesionales';
                end;
            '614':
                begin
                    ft."Regimen Fiscal" := '614 - Ingresos por intereses';
                end;
            '616':
                begin
                    ft."Regimen Fiscal" := '616 - Sin obligaciones fiscales';
                end;
            '620':
                begin
                    ft."Regimen Fiscal" := '620 - Sociedades Cooperativas de Producción que optan por diferir sus ingresos';
                end;
            '621':
                begin
                    ft."Regimen Fiscal" := '621 - Incorporación Fiscal';
                end;
            '622':
                begin
                    ft."Regimen Fiscal" := '622 - Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras';
                end;
            '623':
                begin
                    ft."Regimen Fiscal" := '623 - Opcional para Grupos de Sociedades';
                end;
            '624':
                begin
                    ft."Regimen Fiscal" := '624 - Coordinados';
                end;
            '628':
                begin
                    ft."Regimen Fiscal" := '628 - Hidrocarburos';
                end;
            '607':
                begin
                    ft."Regimen Fiscal" := '607 - Régimen de Enajenación o Adquisición de Bienes';
                end;
            '629':
                begin
                    ft."Regimen Fiscal" := '629 - De los Regímenes Fiscales Preferentes y de las Empresas Multinacionales';
                end;
            '630':
                begin
                    ft."Regimen Fiscal" := '630 - Enajenación de acciones en bolsa de valores';
                end;
            '615':
                begin
                    ft."Regimen Fiscal" := '615 - Régimen de los ingresos por obtención de premios';
                end;
        end;
        //Emisor//End
        //Receptor//Start
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@Nombre', nsm, node);
        txt := node.AsXmlAttribute();
        ft.NombreReceptor := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@Rfc', nsm, node);
        txt := node.AsXmlAttribute();
        ft.RfcReceptor := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Receptor/@UsoCFDI', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            'G01':
                begin
                    ft.UsoCFDI := 'G01 - Adquisición de mercancias';
                end;
            'G02':
                begin
                    ft.UsoCFDI := 'G02 - Devoluciones, descuentos o bonificaciones';
                end;
            'G03':
                begin
                    ft.UsoCFDI := 'G03 - Gastos en general';
                end;
            'I01':
                begin
                    ft.UsoCFDI := 'I01 - Construcciones';
                end;
            'I02':
                begin
                    ft.UsoCFDI := 'I02 - Mobilario y equipo de oficina por inversiones';
                end;
            'I03':
                begin
                    ft.UsoCFDI := 'I03 - Equipo de transporte';
                end;
            'I04':
                begin
                    ft.UsoCFDI := 'I04 - Equipo de computo y accesorios';
                end;
            'I05':
                begin
                    ft.UsoCFDI := 'I05 - Dados, troqueles, moldes, matrices y herramental';
                end;
            'I06':
                begin
                    ft.UsoCFDI := 'I06 - Comunicaciones telefónicas';
                end;
            'I07':
                begin
                    ft.UsoCFDI := 'I07 - Comunicaciones satelitales';
                end;
            'I08':
                begin
                    ft.UsoCFDI := 'I08 - Otra maquinaria y equipo';
                end;
            'D01':
                begin
                    ft.UsoCFDI := 'D01 - Honorarios médicos, dentales y gastos hospitalarios.';
                end;
            'D02':
                begin
                    ft.UsoCFDI := 'D02 - Gastos médicos por incapacidad o discapacidad';
                end;
            'D03':
                begin
                    ft.UsoCFDI := 'D03 - Gastos funerales.';
                end;
            'D04':
                begin
                    ft.UsoCFDI := 'D04 - Donativos.';
                end;
            'D05':
                begin
                    ft.UsoCFDI := 'D05 - Intereses reales efectivamente pagados por créditos hipotecarios (casa habitación).';
                end;
            'D06':
                begin
                    ft.UsoCFDI := 'D06 - Aportaciones voluntarias al SAR.';
                end;
            'D07':
                begin
                    ft.UsoCFDI := 'D07 - Primas por seguros de gastos médicos.';
                end;
            'D08':
                begin
                    ft.UsoCFDI := 'D08 - Gastos de transportación escolar obligatoria.';
                end;
            'D09':
                begin
                    ft.UsoCFDI := 'D09 - Depósitos en cuentas para el ahorro, primas que tengan como base planes de pensiones.';
                end;
            'D10':
                begin
                    ft.UsoCFDI := 'D10 - Pagos por servicios educativos (colegiaturas)';
                end;
            'P01':
                begin
                    ft.UsoCFDI := 'P01 - Por definir';
                end;
        end;
        //Receptor//End
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Impuestos/@TotalImpuestosTrasladados', nsm, node);
        txt := node.AsXmlAttribute();
        if read then begin
            read := Evaluate(ImpTras, txt.Value());
            Evaluate(ft.IVA, txt.Value());

        end;
        //Footer//Start 
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@UUID', nsm, node);
        txt := node.AsXmlAttribute();
        ft.UUID := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@FechaTimbrado', nsm, node);
        txt := node.AsXmlAttribute();
        ft.FechaTimbrado := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/@NoCertificado', nsm, node);
        txt := node.AsXmlAttribute();
        ft.NoCertificado := txt.Value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@NoCertificadoSAT', nsm, node);
        txt := node.AsXmlAttribute();
        ft.NoCertificadoSAT := txt.value();
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@SelloCFD', nsm, node);
        txt := node.AsXmlAttribute();
        ft.SelloDigitalCFD := txt.Value;
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:Complemento/tfd:TimbreFiscalDigital/@SelloSAT', nsm, node);
        txt := node.AsXmlAttribute();
        ft.SelloSAT := txt.Value;
        //Footer//End


        ft.CertificadoCadena := '||' + ft.Version + '|' + ft.UUID + '|' + ft.FechaTimbrado + '|' + ft."RFC provedor" + '|' + ft.SelloDigitalCFD + '|' + ft.NoCertificadoSAT + '||';


        //"Tipo relacion" Notas de Crédito
        read := xmlDoc.SelectSingleNode('/x:Comprobante/x:CfdiRelacionados/@TipoRelacion', nsm, node);
        txt := node.AsXmlAttribute();
        case txt.Value() of
            '01':
                begin
                    ft."Tipo relacion" := '01 - Nota de crédito de los documentos relacionados';
                end;
            '02':
                begin
                    ft."Tipo relacion" := '02 - Nota de débito de los documentos relacionados';
                end;
            '03':
                begin
                    ft."Tipo relacion" := '03 - Devolución de mercancía sobre facturas o traslados previos';
                end;
            '04':
                begin
                    ft."Tipo relacion" := '04 - Sustitución de los CFDI previos';
                end;
            '05':
                begin
                    ft."Tipo relacion" := '05 - Traslados de mercancias facturados previamente';
                end;
            '06':
                begin
                    ft."Tipo relacion" := '06 - Factura generada por los traslados previos';
                end;
            '07':
                begin
                    ft."Tipo relacion" := '07 - CFDI por aplicación de anticipo';
                end;
            '08':
                begin
                    ft."Tipo relacion" := '08 - Factura generada por pagos en parcialidades';
                end;
            '09':
                begin
                    ft."Tipo relacion" := '09 - Factura generada por pagos diferidos';
                end;
            else
        // ft."Tipo relacion" := salesInvoiceHeader.RelationType;
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
            ft."UUID Relacionado" += txt.Value() + FORMAT(CR, 0, '<CHAR>') + FORMAT(LF, 0, '<CHAR>');
            cursor := cursor + 1;
        end;
        //UUID Relacionados End
        //UUID Folio Relacionado
        if ft."UUID Relacionado" <> '' then begin
            ft."UUID Relacionado" := ft."UUID Relacionado";
        end
        else begin
            //  ft.FolioRelacionado := '';
        end;
        //UUID Folio Relacionado End
        //Lineas//Start
        read := xmlDoc.SelectNodes('/x:Comprobante/x:Conceptos/x:Concepto', nsm, nodeList);
        cursor := 1;
        totalCursor := nodeList.Count();
        while (cursor <= totalCursor) do begin
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@NoIdentificacion', nsm, node);
            txt := node.AsXmlAttribute();
            ftc.NoIdentificacion := txt.Value();

            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ClaveProdServ', nsm, node);
            txt := node.AsXmlAttribute();
            ftc.ClaveProdServ := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ClaveUnidad', nsm, node);
            txt := node.AsXmlAttribute();
            ftc.ClaveUnidad := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Cantidad', nsm, node);
            txt := node.AsXmlAttribute();
            Evaluate(ftc.Cantidad, txt.Value());
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Descripcion', nsm, node);
            txt := node.AsXmlAttribute();
            ftc.Descripcion := txt.Value();
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@ValorUnitario', nsm, node);
            txt := node.AsXmlAttribute();
            read := Evaluate(formato, txt.Value());
            Evaluate(ftc.ValorUnitario, Format(formato, 0, '<Sign><Integer Thousand><Decimals><Comma,.>'));
            read := nodeList.Get(cursor, node);
            read := node.SelectSingleNode('@Importe', nsm, node);
            txt := node.AsXmlAttribute();
            read := Evaluate(formato, txt.Value());
            evaluate(ftc.Importe, Format(formato, 0, '<Sign><Integer Thousand><Decimals><Comma,.>'));
            ftc.Descuento := salesInvoiceHeader."Invoice Discount Amount";
            read := nodeList.Get(cursor, node);
            read := node.SelectNodes('/x:Comprobante/x:Conceptos/x:Concepto/x:Impuestos/x:Traslados/x:Traslado', nsm, nodeTaxList);
            cursorTax := 1;
            totalCursorTax := nodeTaxList.Count();
            while (cursorTax <= totalCursorTax) do begin
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@TipoFactor', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                ftc.TipoFactor := txt.Value();
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@TasaOCuota', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                read := Evaluate(formato, txt.Value());
                ftc.TasaOCuotaTraslado := Format((formato * 100), 0, '<precision, 4:4><standard format,0>%');
                read := nodeTaxList.Get(cursorTax, nodeTax);
                read := nodeTax.SelectSingleNode('@Impuesto', nsm, nodeTax);
                txt := nodeTax.AsXmlAttribute();
                TipoImpuesto := txt.Value();
                if TipoImpuesto = '002' then begin
                    ftc.ImpuestoTraslado := 'IVA';
                    ftc.TipoFactor := 'Tasa';
                    read := nodeTaxList.Get(cursorTax, nodeTax);
                    read := nodeTax.SelectSingleNode('@Base', nsm, nodeTax);
                    txt := nodeTax.AsXmlAttribute();
                    read := Evaluate(SumaBase, txt.Value());
                    SumBaseLineAmount += SumaBase;
                    //ftc.Base1 := txt.Value();
                    read := nodeTaxList.Get(cursorTax, nodeTax);
                    read := nodeTax.SelectSingleNode('@Importe', nsm, nodeTax);
                    txt := nodeTax.AsXmlAttribute();
                    read := Evaluate(SumaIva, txt.Value());
                    SumaTaxLineAmount += SumaIva;
                    //ftc.TaxLineAmount := txt.Value();                  
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
            Evaluate(ftc.BaseTraslado, Format(SumBaseLineAmount, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>'));
            Evaluate(ftc.ImporteTraslado, Format(SumaTaxLineAmount, 0, '<Sign><Integer Thousand><Decimals><Comma,.>'));
            if SumaIeps > 0 then begin
                read := Evaluate(LineAmount, format(ftc.Importe));
                LineAmount += SumaIeps;

                read := Evaluate(LineQty, format(ftc.Cantidad));
                LineUnitValue := LineAmount / LineQty;
                Evaluate(ftc.ValorUnitario, Format(LineUnitValue, 0, '<Sign><Integer Thousand><Decimals><Comma,.>'));
                Subtotal += SumaIeps;
                ImpTras -= SumaIeps;
            end;
            cursor := cursor + 1;
            ftc.Insert();
            ftc.id := ftc.id + 1;
            Commit();
        end;


        lenghtLEC := StrLen(ft.SelloDigitalCFD);
        lenghtLECF := lenghtLEC - 7;
        lastEightCert := FT.SelloDigitalCFD.Substring(lenghtLECF);

        ft."QR String" := 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?id=' + ft.UUID + '%26re=' + ft.RFC + '%26rr=' + ft.RfcReceptor + '%26tt=' + Format(ft.Total) + '%26fe=' + lastEightCert;

        Evaluate(ft.IVA, Format(ImpTras, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>'));
        Evaluate(ft.SubTotal, Format(Subtotal, 0, '<precision, 2:2><Sign><Integer Thousand><Decimals><Comma,.>'));
        //Lineas//End
        if ft.Insert() then begin
            Message('Se agrego XML correctamente');
            Commit();
        end
        else
            Message('Factura ya timbrada');
        ft.Modify();


    end;


    var


        lastEightCert: Text;
        lenghtLECF: Integer;
        lenghtLEC: Integer;
        numUnidades: text;

        insertUUID: Codeunit getStamp;
        cod: Codeunit codeUnitWS;
        unidadesDecena: Text;
        unidadDec: Integer;
        httpCliente: HttpClient;
        ResponseMessage: HttpResponseMessage;
        montoGlobal: Text;
        moneda: Text;
        bool: Boolean;
}