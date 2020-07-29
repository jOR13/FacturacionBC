tableextension 70104 CustumerTableExt extends Customer
{
    fields
    {
        field(70104; PermisoCodeCliente; Code[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = permisosCRE.code where(Comercializacion = const(true));
        }
    }
}