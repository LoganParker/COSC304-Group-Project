<%
try {
    getConnection();
    String sql = "SELECT * FROM customer";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();
    out.println("<br><h1>Customer Information</h1><table><thead>");
    out.print("<tr><th>custId</th><th>firstName</th><th>lastName</th><th>userid</th><th>password</th></tr>");
    out.println("</thead><tbody>");
    while(rst.next()){
        //index attributes from values 1,2,3, 11, 12. Refer to customer table
        int[] arr = {1,2,3,11,12};
        ArrayList<String> attributeList = new ArrayList<String>();
        //add strings to a list
        for(int i:arr){
            attributeList.add(rst.getString(i));
        }
        //create new row in table and fill it w/ values 
        out.print("<tr>");
            for(String attr:attributeList){
                out.println("<td>"+attr+"</td>");
            }
        out.println("</tr>");
    }
    out.print("</tbody></table>"); 
} catch (SQLException ex) {
    out.print(ex);
}finally{
    closeConnection();
}
%>