<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <title>D&D Pets Store</title>
</head>
<body>
<%@include file="header.jsp"%>
<h2 align="center" class="subheaderText font-effect-fire-animation">Products</h1>
<div class="centerDiv">
    <div style="padding-top: 10px">
        <form method="get" action="listprod.jsp">
            <input type="text" name="productName" size="50" maxlength="40">
            <input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
            <select name="category" id="category">
                <option value=""> </option> 
            <%
                String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
                String uid = "SA";
                String pw = "YourStrong@Passw0rd";            
                try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
                    String SQL = "SELECT categoryId,categoryName FROM category";
                    PreparedStatement pstmt = con.prepareStatement(SQL);
                    ResultSet rst = pstmt.executeQuery();
                    while(rst.next()){
                        String categoryId = rst.getString(1);
                        String categoryName = rst.getString(2);
                        out.println("<option value=\""+categoryId+"\">"+categoryName+"</option>");
                    }
                }catch (Exception ex) {
                    out.println(ex);
                }

                %>
            </select>
                
            
        </form>
        <%-- This table is where all our products are output to--%>
        <table>
            <% // Get product name to search for
                String name = request.getParameter("productName");
                String category = request.getParameter("category");
                //Note: Forces loading of SQL Server driver
                try {    // Load driver class
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                } catch (java.lang.ClassNotFoundException e) {
                    out.println("ClassNotFoundException: " + e);
                }

                // Make the connection

                Locale locale = new Locale("en", "US");
                NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
                try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
                    String SQL = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc, SUM(orderproduct.quantity) as amountSold FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId";
                    boolean hasName = (name != null) && (!name.equals(""));
                    boolean hasCategory = false;
                    if (category != null){
                        hasCategory = !category.equals("");
                    }
                    PreparedStatement pstmt = null;
                    ResultSet rst = null;
                    
                    //If there is a category but no name
                    if (hasCategory && !hasName) { 
                        SQL += " WHERE product.categoryId = ?";
                        SQL += " GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY amountSold DESC, product.productName";
                        pstmt = con.prepareStatement(SQL);
                        pstmt.setString(1, category);
                    // Takes care of casses if there is an input name
                    } else if (hasName) { 
                        name = "%" + name + "%";
                        SQL += " WHERE product.productName LIKE ?";

                        //We check here if the user has inputted a category along with a product name. If they have we append the categoryId to the SELECT
                        if( hasCategory ){
                            SQL += " AND categoryId = ?";
                            SQL += " GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY amountSold DESC, product.productName";
                            pstmt = con.prepareStatement(SQL);
                            pstmt.setString(2, category);

                        //If no category has been input we just run the else statement
                        }else{ 
                            SQL += " GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY amountSold DESC, product.productName";
                            pstmt = con.prepareStatement(SQL); 
                        }
                        pstmt.setString(1, name);

                    //No filters
                    }else if(!hasName){
                        SQL += " GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY amountSold DESC, product.productName";
                        pstmt = con.prepareStatement(SQL);
                    }
                    
                    rst = pstmt.executeQuery();
                    int counter = 0;

					/**
                     * Generate product cards for the table
                     * */
                     
					while (rst.next()) {
                        String productId = rst.getString(1);
                        String productName = rst.getString(2);
                        String price = rst.getString(3);
                        String imageURL = rst.getString(4);
						String imageDesc = rst.getString(5);
                        String itemDesc = rst.getString(6);
                        // addcart.jsp?id=productId&name=productName&price=productPrice
                        String addCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + price;

                        if(counter == 3){
                            out.println("</tr>");
							counter = 0;
                        }
                        //Start of new row in the table
                        if(counter == 0){
                            out.println("<tr>");
                        }
						out.println("<td>");
						out.println("<div class = \"card\">");
                        out.println("<img src=\""+imageURL+"\" alt=\""+imageDesc+"\" style=\"max-width:50%; max-height:50%\">");
						/**Prints productId with productName*/
						//out.println("<h1>"+productId+" "+productName+"</h1>");
                        out.println("<h1><a href = \"product.jsp?id="+productId+"\">"+productName+"</a></h1>");

                        out.println("<p class=\"price\">"+price+"</p>");
                        out.println("<p>"+itemDesc+"</p>");
						out.println("<p><button><a href=\""+addCartLink+"\">Add to Cart</a></button></p>");
                        out.println("</td>");
						counter++;
                    }
					out.println("</tr>");


                    // For each product create a link of the form

                }
                // Close connection
                catch (SQLException ex) {
                    throw(ex);
                    // out.println(ex);
                }


            %>
        </table>
    </div>
</div>


</body>
</html>