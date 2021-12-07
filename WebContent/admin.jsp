<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@include file="header.jsp"%>
<div class="centerDiv"style="background-color: white">

<%


// List all customers 
                try  {
                    getConnection();
                    String sql = "SELECT * FROM customer";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    ResultSet rst = pstmt.executeQuery();
                   
                   
                
                    out.println("<br><h4>Customer Information</h4><table><thead>");
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

                out.println("<h4>Order and Sales Report Table</h4><table><thead>");
                out.print("<tr><th>orderDate</th><th>orderId</th><th>customerId</th><th>totalAmount</th></th>");
                sql = "SELECT orderDate, orderId, customerId, totalAmount FROM ordersummary ORDER BY orderDate DESC";
                out.print("</thead><tbody>"); 
                pstmt = con.prepareStatement(sql);
                rst = pstmt.executeQuery();
                
                while(rst.next()){
                int[] arr = {1, 2, 3, 4};
                ArrayList<String> attributeList = new ArrayList<String>();

                for(int i: arr) {
                    attributeList.add(rst.getString(i));
                }

                // Create a new new and insert attributes 
                out.print("<tr>");
                for(String attr : attributeList) {
                    out.print("<td>"+attr+"</td>");
                }
                out.print("</tr>");
                }
                out.print("</tbody></table>");
                    
                }catch (Exception ex) {
                    out.println(ex);
                } finally {
                    closeConnection();
                }
//String sql = "Select SUM(totalAmount) FROM ordersummary GROUP BY orderDate";
%>

<!--Add new product -->
<form method="post" action="insertProduct.jsp">
    <br>
    <h1> Insert Product </h1>
    <div>
    <div>
    <label> Product Name </label>
    <input type="text" name="productName" placeholder="wonderous item goes here">
    </div>
    <label> Product Price </label>
    <input type="text" name="productPrice" placeholder="wonderous item price here" >
    <br>
    <label> Image URL  </label>
    <input type="text" name="productImageURL" placeholder="https://monster.png">
    <div>
    <label> Product Description </label>
    <input type="text" name="productDesc" placeholder="item flavour text goes here">
    </div>
    <div>
    <label> Category  Name</label>
    <input type="text" name="categoryName" placeholder="item category">
    </div>
    </div>
    <input type="submit" value="Submit"><input type="reset" value="Reset">
    <h1> Restore Database </h1> 
    <a href = "loaddata.jsp"> 
    <input type=button value="Restore Database"> 
    </a> 


</form>

<!--Update / Delete Product -->
<form method="get" action="admin.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> 
<table>
<%
String productName = request.getParameter("productName");
try{
    getConnection();
    String sql = "SELECT * FROM product WHERE productName LIKE ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    productName = '%'+ productName + '%';
    pstmt.setString(1, productName); //possible error here 
    ResultSet rst = pstmt.executeQuery();
    String[] colNames = {"productId","productName","productPrice","productDesc","categoryId", "Update", "Delete"};
    out.print("<tr>");
    for(String i: colNames){
        out.print("<th>"+i+"</th>");}
    out.print("</tr>");
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
</table>



</div>
</body>
</html>

