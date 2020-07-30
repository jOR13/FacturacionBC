tableextension 70100 LocationTableExt extends Location
{
    fields
    {
        field(70100; PermisoCode; Code[250])
        {
            DataClassification = ToBeClassified;
            InitValue = '';
            TableRelation = permisosCRE.code where(Comercializacion = const(false));
        }
    }

    var
        myInt: Integer;
}