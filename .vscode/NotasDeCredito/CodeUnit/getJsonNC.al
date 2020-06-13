codeunit 50603 GetJsonNC
{

    [EventSubscriber(ObjectType::Page, page::"Posted Sales Credit Memos", 'OnOpenPageEvent', '', true, true)]

    procedure Refresh();
    var
        ft: Record NCTimbradas;
        ftc: Record ConceptosNC;
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
        URLSANDBOX: text;
    begin
        URLSANDBOX := 'https://jor13.github.io/ALCurso/';
        URL := 'http://hgwebapp.azurewebsites.net/api/factura/E';

        if not HttpClient.Get(URL, ResponseMessage)
        then
            Error('La llamada al servicio web falló.');
        if not ResponseMessage.IsSuccessStatusCode then
            error('El servicio web devolvió el siguiente mensaje:\\' + 'Respuesta: %1\' + 'Description: %2',
                  ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(JsonText);
        if not JsonArray.ReadFrom(JsonText) then
            Error('Respuesta invalida, Se espera un JSON array como objeto');
        foreach t in JsonArray do begin
            // for i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            //e := (SelectJsonToken(JsonObject, '$.[').AsArray().Count());
            JsonObject := JsonToken.AsObject;
            ft.init;

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
            ft."Regimen Fiscal" := SelectJsonToken(JsonObject, '$.Emisor.RegimenFiscal').AsValue.AsText();
            ft.UsoCFDI := SelectJsonToken(JsonObject, '$.Receptor.UsoCFDI').AsValue.AsText();

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

            ft.Fecha := SelectJsonToken(JsonObject, '$.Fecha').AsValue.AsText();
            ft.Nombre := SelectJsonToken(JsonObject, '$.Emisor.Nombre').AsValue.AsText;
            ft.RFC := SelectJsonToken(JsonObject, '$.Emisor.Rfc').AsValue.AsText;
            ft.Folio := SelectJsonToken(JsonObject, '$.Folio').AsValue.AsText;
            ft.Subtotal := SelectJsonToken(JsonObject, '$.SubTotal').AsValue.AsDecimal();
            ft.IVA := SelectJsonToken(JsonObject, '$.Impuestos.TotalImpuestosTrasladados').AsValue.AsDecimal();
            ft.Total := SelectJsonToken(JsonObject, '$.Total').AsValue.AsDecimal();
            ft.UUID := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@UUID').AsValue.AsText;
            ft.SelloDigitalCFD := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@SelloCFD').AsValue.AsText;
            ft.SelloSAT := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@SelloSAT').AsValue.AsText;
            ft.NoCertificado := SelectJsonToken(JsonObject, '$.NoCertificado').AsValue.AsText;
            ft.NoCertificadoSAT := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@NoCertificadoSAT').AsValue.AsText;
            ft.FechaTimbrado := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@FechaTimbrado').AsValue.AsText;
            ft.NombreReceptor := SelectJsonToken(JsonObject, '$.Receptor.Nombre').AsValue.AsText;
            ft.RFCReceptor := SelectJsonToken(JsonObject, '$.Receptor.Rfc').AsValue.AsText;
            ft.TotalText := SelectJsonToken(JsonObject, '$.Total').AsValue.AsText();
            ft.TipoCambio := SelectJsonToken(JsonObject, '$.TipoCambio').AsValue.AsText();
            ft."RFC provedor" := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@RfcProvCertif').AsValue.AsText;
            ft.Version := SelectJsonToken(JsonObject, '$.Complemento.[0].Any.[0].tfd:TimbreFiscalDigital.@Version').AsValue.AsText;
            ft.CertificadoCadena := '||' + ft.Version + '|' + ft.UUID + '|' + ft.FechaTimbrado + '|' + ft."RFC provedor" + '|' + ft.SelloDigitalCFD + '|' + ft.NoCertificadoSAT + '||';
            if SelectJsonToken(JsonObject, '$.CfdiRelacionados.TipoRelacion').AsValue.AsText() <> '' then begin
                ft."UUID Relacionado" := SelectJsonToken(JsonObject, '$.CfdiRelacionados.CfdiRelacionado.[0].UUID').AsValue.AsText();
                ft."Tipo relacion" := SelectJsonToken(JsonObject, '$.CfdiRelacionados.TipoRelacion').AsValue.AsText();
            end;
            if SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() = 'MXN' then
                ft.Moneda := SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() + ' Peso Mexicano'
            else
                ft.Moneda := SelectJsonToken(JsonObject, '$.Moneda').AsValue.AsText() + ' Dolar Americano';
            rfcReceptor := SelectJsonToken(JsonObject, '$.Receptor.Rfc').AsValue.AsText;
            ft."QR String" := 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?id=' + ft.UUID + '%26re=' + ft.RFC + '%26rr=' + rfcReceptor + '%26tt=' + Format(ft.Total) + '%26fe=03316950';
            cont := (SelectJsonToken(JsonObject, '$.Conceptos').AsArray().Count());

            for j := 0 to cont - 1 do begin
                ftc.Init();
                ftc.Descripcion := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Descripcion').AsValue.AsText;
                ftc.Cantidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Cantidad').AsValue.AsDecimal();
                ftc.ClaveProdServ := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ClaveProdServ').AsValue.AsText;
                ftc.ClaveUnidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ClaveUnidad').AsValue.AsText;
                // ftc.NoIdentificacion := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].NoIdentificacion').AsValue.AsText;
                ftc.Unidad := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Unidad').AsValue.AsText;
                ftc.ValorUnitario := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].ValorUnitario').AsValue.AsDecimal();
                ftc.Importe := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Importe').AsValue.AsDecimal();

                if SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].DescuentoSpecified').AsValue.AsText = 'false' then begin
                    ftc.BaseTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Base').AsValue.AsDecimal();
                    ftc.ImpuestoTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Impuesto').AsValue().AsText();
                    ftc.TasaOCuotaTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].TasaOCuota').AsValue.AsText();
                    ftc.TipoFactor := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].TipoFactor').AsValue.AsText();
                    ftc.ImporteTraslado := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Impuestos.Traslados.[0].Importe').AsValue.AsDecimal();

                end else begin
                    ftc.Descuento := SelectJsonToken(JsonObject, '$.Conceptos.[' + Format(j) + '].Descuento').AsValue.AsDecimal();
                    ft.DescuentoTotal := SelectJsonToken(JsonObject, '$.Descuento').AsValue.AsDecimal();
                end;

                ftc.Folio := ft.Folio;
                ftc.Insert();
                ftc.id := ftc.id + 1;
            end;

            if ft.Insert() then begin
                ft.id := ft.id + 1;
                i += 1;
            end else begin
                ft.Next();
            end;
        end;
        Commit();
        //getDiscount();

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



    procedure calCImporteTrasladoNC()
    var
        sml: Record "Sales Cr.Memo Line";
        t: Record trasladoNC;
        tt: Record totalTrasladosNC;
        iva: Decimal;
        lol: Decimal;
    begin
        CurrentDate := Today();
        sml.SetFilter(sml."Posting Date", '%1..%2', CALCDATE('-30D', CurrentDate), CALCDATE('-0D', CurrentDate));
        t.DeleteAll();
        tt.DeleteAll();
        if sml.FindSet() then begin
            repeat begin
                t.Init();
                t.Folio := sml."Document No.";
                t.Base := sml.Amount;
                t.impuesto := '002';
                if sml."VAT Identifier" = 'IVA8' then begin
                    T.TasaOCuota := '0.08';
                end else
                    if sml."VAT Identifier" = 'IVA16' then begin
                        T.TasaOCuota := '0.16';
                    end;
                if t.tasaoCuota <> '' then begin
                    EVALUATE(iva, t.tasaoCuota);
                    t.Importe := (sml."Amount Including VAT" - sml."Amount");
                end;


                T.tipoFactor := 'Tasa';
                if t.base <> 0 then begin
                    t.Insert();
                end;
                t.id += 1;
            end until sml.Next() = 0;
            getTotalTrasladosNC();
        end;
    end;

    local procedure getTotalTrasladosNC()
    var
        t: Record trasladoNC;
        tt: Record totalTrasladosNC;
        Importe: Decimal;
    begin
        if t.FindSet() then begin
            repeat begin
                tt.Init();
                tt.Folio := t.Folio;
                tt.importe += t.importe;
                tt.TotalImpuestosTrasladados += t.importe;
                tt.TasaOCuota := t.TasaOCuota;
                tt.tipoFactor := t.tipoFactor;
                tt.impuesto := t.impuesto;
                if tt.importe <> 0 then begin
                    tt.Insert();
                end;
                tt.id += 1;
            end until t.Next() = 0;
        end;
    end;




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

    var
        numUnidades: text;
        unidadesDecena: Text;
        unidadDec: Integer;
        httpCliente: HttpClient;
        ResponseMessage: HttpResponseMessage;
        bool: Boolean;
        existe: Boolean;
        CurrentDate: date;

}