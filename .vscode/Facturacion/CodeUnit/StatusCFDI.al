codeunit 50946 StatusCFDI
{
    procedure GetSatusCFDI(RFCE: text; RFCR: Text; Total: text; uuid: Text) responseText: Text;
    var
        Clint: HttpClient;
        Response: HttpResponseMessage;
        J: JsonObject;
        ResponseTxt: text;
        status, codigo, cancel, estatusCancel : text;
    begin
        if Clint.Get('http://177.244.51.250:2020/api/StatusCFDI?RFCE=' + RFCE + '&RFCR=' + RFCR + '&Total=' + Total + '&uuid=' + uuid + '', Response) then begin
            if Response.IsSuccessStatusCode then begin
                Response.Content().ReadAs(ResponseTxt);
                J.ReadFrom(ResponseTxt);
                codigo := GetJesonTextField(J, 'CodigoEstatus');
                status := GetJesonTextField(J, 'Estado');
                cancel := GetJesonTextField(J, 'EsCancelable');
                estatusCancel := GetJesonTextField(J, 'EstatusCancelacion');
                responseText := (status + ', ' + cancel + ' ' + estatusCancel + ' ');
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

    var
        myInt: Integer;
}