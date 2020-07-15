codeunit 50503 codeUnitWS
{
    procedure Refresh();
    var
        filtro: text;
        fechaFil: text;
        fbc, fechaF : text;
        fecha: List of [Text];
    begin
        consultaWS('http://177.244.51.250:2020/api/facturashabilitadas');
        //consultaWS('http://hgwebapp.azurewebsites.net/api/facturashabilitadas');

        foreach t in JsonArray do begin
            contArray := JsonArray.Count;
            for i := 0 to contArray - 1 do begin
                JsonArray.Get(i, JsonToken);
                JsonObject := JsonToken.AsObject;
                ft.init;
                //  fechaFil := Format(SelectJsonToken(JsonObject, '$.Fecha').AsValue.AsDateTime(), 0, '<Month,2>/<Day>/<Year4>');
                // filtro := getFilter();
                // if fechaFil = filtro then begin

                ft.Folio := SelectJsonToken(JsonObject, '$.Folio').AsValue.AsText;
                ft.tipoDeComprobante := SelectJsonToken(JsonObject, '$.TipoDeComprobante').AsValue.AsText();
                if ft.tipoDeComprobante = 'I' then
                    ft.tipoDeComprobante := 'I - Ingreso'
                else
                    ft.tipoDeComprobante := 'E - Egreso';
                ft."Metodo de pago" := SelectJsonToken(JsonObject, '$.MetodoPago').AsValue.AsText();
                if ft."Metodo de pago" = 'PPD' then
                    ft."Metodo de pago" += '- Pago en parcialidades o diferido'
                else
                    ft."Metodo de pago" += '- Pago en una sola exhibición';
                ft."Lugar de expedición" := SelectJsonToken(JsonObject, '$.LugarExpedicion').AsValue.AsText();
                case SelectJsonToken(JsonObject, '$.Emisor.RegimenFiscal').AsValue.AsText() of
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
                case SelectJsonToken(JsonObject, '$.Receptor.UsoCFDI').AsValue.AsText() of
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
                ft.FormaDePago := SelectJsonToken(JsonObject, '$.FormaPago').AsValue.AsText();
                case ft.FormaDePago of
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

                fechaF := SelectJsonToken(JsonObject, '$.Fecha').AsValue.AsText();
                fecha := fechaF.Split('T');
                foreach fbc in fecha do begin
                    if fbc.Contains(':') then begin

                    end else
                        Evaluate(ft.FechaBC2, fbc);
                end;
                ft.Fecha := Format(SelectJsonToken(JsonObject, '$.Fecha').AsValue.AsDateTime(), 0, '<Day>/<Month Text>/<Year4> - <Hours24>:<Minutes,2>:<Seconds,2>');
                ft.FechaTimbrado := Format(SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@FechaTimbrado').AsValue.AsDateTime(), 0, '<Day,2>/<Month,2>/<Year4> - <Hours24>:<Minutes,2>:<Seconds,2>');
                ft.Nombre := SelectJsonToken(JsonObject, '$.Emisor.Nombre').AsValue.AsText;
                ft.RFC := SelectJsonToken(JsonObject, '$.Emisor.Rfc').AsValue.AsText;
                ft.Subtotal := SelectJsonToken(JsonObject, '$.SubTotal').AsValue.AsDecimal();
                ft.IVA := SelectJsonToken(JsonObject, '$.Impuestos.TotalImpuestosTrasladados').AsValue.AsDecimal();
                ft.Total := SelectJsonToken(JsonObject, '$.Total').AsValue.AsDecimal();
                ft.UUID := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@UUID').AsValue.AsText;
                ft.SelloDigitalCFD := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@SelloCFD').AsValue.AsText;
                ft.SelloSAT := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@SelloSAT').AsValue.AsText;
                ft.NoCertificado := SelectJsonToken(JsonObject, '$.NoCertificado').AsValue.AsText;
                ft.NoCertificadoSAT := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@NoCertificadoSAT').AsValue.AsText;
                ft.NombreReceptor := SelectJsonToken(JsonObject, '$.Receptor.Nombre').AsValue.AsText;
                ft.RFCReceptor := SelectJsonToken(JsonObject, '$.Receptor.Rfc').AsValue.AsText;
                ft.TotalText := SelectJsonToken(JsonObject, '$.Total').AsValue.AsText();
                if SelectJsonToken(JsonObject, '$.TipoCambioSpecified').AsValue.AsBoolean() = true then begin
                    ft.TipoCambio := SelectJsonToken(JsonObject, '$.TipoCambio').AsValue.AsText();
                end;
                ft."RFC provedor" := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@RfcProvCertif').AsValue.AsText;
                ft.Version := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@Version').AsValue.AsText;
                ft.CertificadoCadena := '||' + ft.Version + '|' + ft.UUID + '|' + ft.FechaTimbrado + '|' + ft."RFC provedor" + '|' + ft.SelloDigitalCFD + '|' + ft.NoCertificadoSAT + '||';
                if SelectJsonToken(JsonObject, '$.CfdiRelacionados.TipoRelacion').AsValue.AsText() <> '' then begin
                    ft."UUID Relacionado" := SelectJsonToken(JsonObject, '$.CfdiRelacionados.CfdiRelacionado.[0].UUID').AsValue.AsText();
                    case SelectJsonToken(JsonObject, '$.CfdiRelacionados.TipoRelacion').AsValue.AsText() of
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

                    end;
                end;
                if SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() = 'MXN' then
                    ft.Moneda := SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() + ' Peso Mexicano'
                else
                    ft.Moneda := SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() + ' Dolar Americano';
                rfcReceptor := SelectJsonToken(JsonObject, '$.Receptor.Rfc').AsValue.AsText;
                lenghtLEC := StrLen(ft.SelloDigitalCFD);
                lenghtLECF := lenghtLEC - 7;
                lastEightCert := FT.SelloDigitalCFD.Substring(lenghtLECF);
                ft."QR String" := 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?id=' + ft.UUID + '%26re=' + ft.RFC + '%26rr=' + rfcReceptor + '%26tt=' + Format(ft.Total) + '%26fe=' + lastEightCert;



                if ft.Insert() then begin
                    ft.id := ft.id + 1;
                    i += 1;
                    //Consulta ws para conceptos
                    //consultaWS('https://jor13.github.io/ALCurso/');
                    cont := SelectJsonToken(JsonObject, '$.Conceptos').AsArray().Count();
                    for j := 0 to cont - 1 do begin
                        ftc.Init();
                        ftc.Folio := SelectJsonToken(JsonObject, '$.Folio').AsValue.AsText;
                        ftc.Descripcion := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Descripcion').AsValue.AsText;
                        ftc.Cantidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Cantidad').AsValue.AsDecimal();
                        ftc.ClaveProdServ := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ClaveProdServ').AsValue.AsText;
                        ftc.ClaveUnidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ClaveUnidad').AsValue.AsText;
                        ftc.NoIdentificacion := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].NoIdentificacion').AsValue.AsText;
                        ftc.Unidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Unidad').AsValue.AsText;
                        ftc.ValorUnitario := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ValorUnitario').AsValue.AsDecimal();
                        ftc.Importe := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Importe').AsValue.AsDecimal();
                        if SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Retenciones').AsArray().Count > 0 then begin
                            ftc.Retencion := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Retenciones.[0].Importe').AsValue.AsDecimal();
                            ft.RetencionesTotales := SelectJsonToken(JsonObject, '$.Impuestos.Retenciones[0].Importe').AsValue.AsDecimal();
                        end;
                        if SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].DescuentoSpecified').AsValue.AsText = 'false' then begin
                            ftc.BaseTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Base').AsValue.AsDecimal();
                            ftc.ImpuestoTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Impuesto').AsValue().AsText();
                            ftc.TasaOCuotaTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].TasaOCuota').AsValue.AsText();
                            ftc.TipoFactor := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].TipoFactor').AsValue.AsText();
                            ftc.ImporteTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Importe').AsValue.AsDecimal();
                        end;

                        if SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].DescuentoSpecified').AsValue.AsText = 'true' then begin
                            ftc.Descuento := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Descuento').AsValue.AsDecimal();
                            ft.DescuentoTotal := SelectJsonToken(JsonObject, '$.Descuento').AsValue.AsDecimal();
                        end;
                        ftc.Insert();
                        ftc.id := ftc.id + 1;
                    end;

                end else
                    ft.Next();
            end;
            Commit();
        end;
    end;

    procedure consultaWS(URL: text)
    var
        myInt: Integer;
    begin

        if not HttpClient.Get(URL, ResponseMessage)
        then
            Error('La llamada al servicio web falló.');
        if not ResponseMessage.IsSuccessStatusCode then begin

            if ResponseMessage.HttpStatusCode = 500 then begin
                Error('Error en la lectura de datos provinientes del portal Hipergas, contacte al administrador del sistema.');
            end else
                error('El servicio web devolvió el siguiente mensaje:\\' + 'Respuesta: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        end;
        ResponseMessage.Content.ReadAs(JsonText);
        JsonArray.ReadFrom(JsonText);

    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        Message('%1', JsonToken);
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('No se puede encontrar el nodo en la ruta %1', TokenKey);
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    var
        j: Integer;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('No se puede encontrar el nodo en  la ruta  %1', Path);

    end;

    procedure calCImporteTraslado()
    var
        sil: Record "Sales Invoice Line";
        t: Record traslado;
        tt: Record totalTraslados;
        iva: Decimal;
        lol: Decimal;
        IC: Record "Item Charge";
        en: Enum "Sales Line Type";
        CurrentDate: date;

    begin
        t.DeleteAll();
        tt.DeleteAll();
        CurrentDate := Today();
        //sil.SetFilter(sil."Posting Date", '%1..%2', CALCDATE('-30D', CurrentDate), CALCDATE('-0D', CurrentDate));
        filtro := getFilter();
        sil.SetFilter(sil."Posting Date", filtro);
        if sil.FindSet() then begin
            repeat begin
                t.Init();
                t.Folio := sil."Document No.";
                t.Base := sil.Amount;
                t.impuesto := '002';

                if sil."VAT Identifier" = 'IVA8' then begin
                    T.TasaOCuota := '0.080000';
                end else
                    if sil."VAT Identifier" = 'IVA16' then begin
                        T.TasaOCuota := '0.160000';
                    end;

                if sil."VAT Identifier" = '' then begin
                    T.TasaOCuota := '0.00';
                end;

                if t.tasaoCuota <> '' then begin
                    EVALUATE(iva, t.tasaoCuota);
                    t.Importe := (sil."Amount Including VAT" - sil."Amount");
                end;

                T.tipoFactor := 'Tasa';
                t.Insert();
                t.id += 1;
            end until sil.Next() = 0;
            getTotalTraslados();
            CalcRetenciones();
        end;
    end;

    local procedure getTotalTraslados()
    var
        t: Record traslado;
        tt: Record totalTraslados;
        Importe: Decimal;

    begin
        if t.FindSet() then begin
            repeat begin
                tt.Init();
                tt.Folio := t.Folio;
                tt.TotalImpuestosTrasladados += t.importe;
                tt.TasaOCuota := t.TasaOCuota;
                tt.tipoFactor := t.tipoFactor;
                tt.impuesto := t.impuesto;
                tt.importe += t.importe;
                tt.Base += t.Base;
                tt.Insert();
                tt.id += 1;
            end until t.Next() = 0;
        end;
    end;

    procedure CalcRetenciones()
    var
        sil: Record "Sales Invoice Line";
        r: Record Retenciones;
        tr: Record totalRetenciones;
        iva: Decimal;
    begin
        r.DeleteAll();
        tr.DeleteAll();
        CurrentDate := Today();
        filtro := getFilter();
        sil.SetFilter(sil."Posting Date", filtro);
        if sil.FindSet() then begin
            repeat begin
                IF (sil."No." = '111-03-03-01') then begin
                    r.Init();
                    r.Folio := sil."Document No.";
                    r.Base := sil.Amount;
                    r.impuesto := '002';
                    r.TasaOCuota := '0.040000';
                    if r.tasaoCuota <> '' then begin
                        EVALUATE(iva, r.tasaoCuota);
                        r.importe := (sil."Amount Including VAT");
                        r.importe := ABS(r.importe);
                    end;
                    r.tipoFactor := 'Tasa';
                    r.Insert();
                    r.id += 1;
                end;
            end until sil.Next() = 0;
            getTotalRetenciones()
        end;
    end;

    local procedure getTotalRetenciones()
    var
        r: Record Retenciones;
        tr: Record totalRetenciones;
        Importe: Decimal;
    begin
        if r.FindSet() then begin
            repeat begin
                tr.Init();
                tr.Folio := r.Folio;
                tr.importe += r.importe;
                tr.TotalImpuestosRetenidos += r.importe;
                tr.TasaOCuota := r.TasaOCuota;
                tr.tipoFactor := r.tipoFactor;
                tr.impuesto := r.impuesto;
                tr.Insert();
                tr.id += 1;
            end until r.Next() = 0;
        end;
    end;

    //.../api/letraimporte?data=4324&moneda=MXN

    procedure MakeRequest(montoGlobal: text; moneda: Text) responseText: Text;
    var
        Clint: HttpClient;
        Response: HttpResponseMessage;
        J: JsonObject;
        ResponseTxt: text;
    begin
        if Clint.Get('http://177.244.51.250:2020/api/letraimporte?data=' + montoGlobal + '&moneda=' + moneda + '', Response) then begin
            if Response.IsSuccessStatusCode then begin
                Response.Content().ReadAs(ResponseTxt);
                J.ReadFrom(ResponseTxt);
                exit(GetJesonTextField(J, 'letra'));
            end;
        end;
    end;

    local procedure GetJesonTextField(O: JsonObject; Member: text): Text
    var
        Result: JsonToken;
    begin
        if O.Get(Member, Result) then begin
            exit(Result.AsValue().AsText());
        end;
    end;
    /*
        procedure MakeRequest(montoGlobal: text; moneda: Text) responseText: Text;
        var
            client: HttpClient;
            request: HttpRequestMessage;
            response: HttpResponseMessage;
            contentHeaders: HttpHeaders;
            content: HttpContent;
            BaseURL: Text;
            requestText: Text;
        begin
            //Message('%1, %2', montoGlobal, moneda);
            BaseURL := 'https://mit-signature-generator.azurewebsites.net/amount';
            requestText := StrSubstNo('{"client":"$taff009","amount":%1,"currency":"%2"}', montoGlobal, moneda);
            content.WriteFrom(requestText);
            content.GetHeaders(contentHeaders);
            contentHeaders.Remove('Content-Type');
            contentHeaders.Add('Content-Type', 'application/json');
            request.Content := content;
            request.SetRequestUri(BaseURL);
            request.Method := 'POST';
            request.Content().ReadAs(requestText);
            client.Send(request, response);
            response.Content().ReadAs(responseText);
            if response.HttpStatusCode = 200 then begin
                numUnidades := responseText;
            end
            else begin
                numUnidades := '';
            end;
        end;
    */
    procedure getFilter() filtroBase: text;
    var
        fil: Record Filtro;
    begin
        fil.Init();
        if fil.FindSet() then begin
            repeat begin
                if fil.filtro <> '' then begin
                    filtroBase := fil.filtro
                end;
            end until fil.Next() = 0;
        end;

    end;


    var
        numUnidades: text;
        unidadesDecena: Text;
        unidadDec: Integer;
        httpCliente: HttpClient;
        bool: Boolean;
        existe: Boolean;
        CurrentDate: date;
        filtro: text;
        ft: Record facturas_Timbradas;
        ftc: Record Conceptos;
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
        t: JsonToken;
        txtSplitCer: Text;
        values: List of [Text];
        item: Text;
        Lenght: Integer;
        txtSplit: Text;
        txtSplit2: Text;
        j: Integer;
        cont: Integer;
        e: Integer;
        base: Codeunit base64;
        rfcReceptor: Text;
        cod: Codeunit getStamp;
        URL: text;

        lastEightCert: Text;
        lenghtLECF: Integer;
        lenghtLEC: Integer;
        fil: Record Filtro;
        URLWebService: Text;
        json: text;
        contArray: Integer;

}