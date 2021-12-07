<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>D&D Pets Inc - Dungeon Inventory</title>
</head>
<body>
<%@include file="header.jsp"%>


<h1> Dungeon Inventroy </h1> 

<form name='a sick form' method ='get' action='warehouse.jsp'> 
 <select name="warehouse" id="warehouse" onchange="this.form.submit()">
 <option value=""> </option> 

 <%
                         
                try {
                    getConnection();    
                    String sql = "SELECT warehouseId,warehouseName FROM warehouse";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    ResultSet rst = pstmt.executeQuery();
                    while(rst.next()){
                        String warehouseId = rst.getString(1);
                        String warehouseName = rst.getString(2);
                        out.println("<option value=\""+warehouseId+"\">"+warehouseName+"</option>");
                    }
            


                out.print("</select></form>"); 

            String warehouse = request.getParameter("warehouse");

            sql = "SELECT product.productId, product.productName, quantity FROM productinventory JOIN warehouse ON productinventory.warehouseId = warehouse.warehouseId JOIN product ON productinventory.productId = product.productId WHERE warehouse.warehouseId = (?) ";

                pstmt = con.prepareStatement(sql);
                pstmt.setString(1,warehouse);

                rst = pstmt.executeQuery();
            
            out.println("<form name=\"UpdateWarehouse\" method=\"get\" action=\"updateWarehouse.jsp\">");
            out.print("<input type=\"hidden\" name=\"warehouseId\"value=\""+warehouse+"\">");    

            out.print("<table><thead>");
            out.print("<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th><input class=\"submit\" type=\"submit\" name=\"Submit2\" value=\"Update\"></th></tr>");
            out.println("</thead><tbody>");
                

                while(rst.next()) {
                    String productId = rst.getString(1);
                    String productName = rst.getString(2);
                    String quantity = rst.getString(3); 

                    out.print("<tr><td>" + productId + "</td><td>" + productName + "</td><td><input type=\"number\" name=\"" + productId + "\" min=0 max=999 value=\"" + quantity + "\"></td></tr>");
                    
                }
                out.println("</tbody></table></form>");
                }catch (Exception ex) {
                    out.println(ex);
                    throw(ex);
                }

                %>









</body>
</html>