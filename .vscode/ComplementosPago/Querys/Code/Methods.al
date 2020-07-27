codeunit 70101 Methods
{
    procedure SerieNO()
    var
        number: Integer;
        permiso: Record PermisosCRE;
    begin

        if permiso.Get() then begin
            if NumberSequence.Exists(permiso."No. Permiso", false) then
                NumberSequence.insert(permiso."No. Permiso");

            number := NumberSequence.Current(permiso."No. Permiso", true);
        end else begin
            Error('No se encontro ningun permiso, agregue uno por favor');
        end;

    end;

    var
        myInt: Integer;
}