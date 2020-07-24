pageextension 70100 LocationCardExt extends "Location Card"
{
    layout
    {
        addafter(General)
        {
            group(Permisos)
            {
                field(PermisoCode; PermisoCode)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}