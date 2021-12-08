<%
String productName = request.getParameter("productName");

//table with update and delete product 
try{
    getConnection();
    String sql = "SELECT * FROM product WHERE productName LIKE ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    productName = '%'+ productName + '%';
    pstmt.setString(1, productName);
    ResultSet rst = pstmt.executeQuery();
    String[] colNames = {"productId","productName","productPrice","productDesc","categoryId", "Update", "Delete"};
    out.print("<tr>");
    for(String i: colNames){
        out.print("<th>"+i+"</th>");}
    out.print("</tr>");

    //print table rows
    while(rst.next()){
        out.print("<tr>");
        int[] idx = {1,2,3,6,7};
        for(int i: idx) {
            out.print("<td>"+rst.getString(i)+"</td>");
            }
        String link = "?productId="+rst.getString(1)+"&productName="+rst.getString(2)+"&productPrice="+rst.getString(3)+"&productDesc="+rst.getString(6)+"&categoryId="+rst.getString(7);
        String[] links= { "updateprod.jsp" + link, "deleteprod.jsp" + link};
        String[] buttonType = {"Update", "Delete"};
        int index = 0;
        for(String i: links){
            out.println("<td><button><a href=\""+i+"\">"+buttonType[index++]+"</a></button></td>");
        }
        out.print("</tr>");   
    }   
    

}catch (Exception ex) {
    out.println(ex);
    //throw(ex);
}finally{
    closeConnection();
}
%>