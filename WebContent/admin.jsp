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
                   
                   
                
                    out.println("<br><h1>Customer Information</h1><table><thead>");
                    out.print("<tr><td>custId</td><td>firstName</td><td>lastName</td><td>userid</td><td>password</td></tr>");
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

                out.println("<h1>Order and Sales Report Table</h1><table><thead>");
                out.print("<tr><td>orderDate</td><td>orderId</td><td>customerId</td><td>totalAmount</td></tr>");
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
<form method="get" action="admin.jsp">
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

</div>
</form>
<%

//create array with recieved parameters
String[] rsArr = {"productName","productPrice","productImageURL","productDesc","categoryName"};
ArrayList<String> rsList = new ArrayList<String>();
for(String i: rsArr){
    rsList.add(request.getParameter(i));
}

//Check if category is in category table
try{
    getConnection();
    String sql = "SELECT categoryId FROM category WHERE categoryName = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, rsList.get(4)); //possible error here 
    ResultSet rst = pstmt.executeQuery();
    
    //Find category Id
    //if query is empty get count of unique id's and increment
    String categoryId = "";
    if(!rst.next()){
        //return amount 
        sql = "SELECT COUNT(*) FROM product GROUP BY categoryId";
        pstmt = con.prepareStatement(sql);
        rst = pstmt.executeQuery();
        rst.next();
        int result = Integer.parseInt(rst.getString(1)) + 1;
        categoryId = Integer.toString(result);
    }else{
        categoryId = rst.getString(1);    
    }

    //insert values into database 
    String vals = "productName,productPrice,productImageURL,productDesc,categoryId";
    rsList.set(4, categoryId);
    String listResults = String.join(", ", rsList);
    out.print(rsList.toString());
    sql = "INSERT INTO product ("+vals+") VALUES ("+rsList+")"; 
    pstmt = con.prepareStatement(sql);
    rst = pstmt.executeQuery();

}catch (Exception ex) {
    
    out.println(ex);
    //throw(ex);
}finally{
    closeConnection();
}

%>
//

//
</body>
</html>

