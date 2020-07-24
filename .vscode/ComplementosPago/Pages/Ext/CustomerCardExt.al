pageextension 70103 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(Permisos)
            {
                field(PermisoCodeCliente; PermisoCodeCliente)
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