codeunit 50906 DescargaMasivaPDFYXML
{
    procedure descargaMasiva(var rango1: integer; rango2: integer)
    var
        myInt: Integer;

        i: Integer;
        Folio: text;
        tablaDescarga: Record Rangos;
    begin
        //HYPERLINK('http://192.168.1.73/timbrado/xmlasync/' + rec."No.");

        for i := rango1 to rango2 do begin
            folio := Format(i);
            download(Folio);
        end;

        tablaDescarga.DeleteAll();

    end;

    local procedure download(folio: Text)
    var
        TempBlob: Record TempBlob temporary;
        XMLIStream: InStream;
        FileName: Text;
    begin
        TempBlob.Blob.CreateInStream(XMLIStream);
        FileName := folio + '.XML';
        if TempBlob.TryDownloadFromUrl('http://hgwebapp.azurewebsites.net/api/xml/' + folio) then begin
            DownloadFromStream(XMLIStream, 'Download File', '', '*.*', FileName);

            folio := '';
        end else begin
            Error('Esta factura no se ha timbrado');
        end;
    end;

    var
        myInt: Integer;
}