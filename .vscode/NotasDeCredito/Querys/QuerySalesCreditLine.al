query 50532 QrySCL
{
    QueryType = Normal;
    elements
    {


        dataitem(Sales_Cr_Memo_Line; "Sales Cr.Memo Line")
        {

            DataItemTableFilter = Amount = filter(<> 0);
            column(Folio; "Document No.") { }

            column(Importe; "Amount")
            {
                Method = sum;
            }
            column(Descripcion; "Description")
            {

            }
            column(Base; amount)
            {
                Method = sum;
            }
            dataitem(ArticuloInfo; Item)
            {
                DataItemLink = "No." = Sales_Cr_Memo_Line."No.";
                column(NoIdentificacion; "No.") { }
                //column(ClaveProdServ; "SAT Item Classification") { }
                /* dataitem(Unit_of_Measure; "Unit of Measure")
                 {
                     DataItemLink = Code = Sales_Cr_Memo_Line."Unit of Measure Code";
                     column(ClaveUnidad; "SAT UofM Classification") { }
                     //column(Unidad; Description) { }
                }*/

            }
        }
    }


    var
        Desc: Text;

    trigger OnBeforeOpen()
    begin

    end;
}