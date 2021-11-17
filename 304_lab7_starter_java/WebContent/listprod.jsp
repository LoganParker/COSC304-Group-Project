<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://fonts.googleapis.com/css?family=MedievalSharp&effect=fire-animation" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="styles.css" rel="stylesheet">
    <style>
        h1 {
            font-family: 'MedievalSharp', cursive;
            font-size: 64px;
        }

    </style>
    <title>D&D Pets Store</title>
</head>
<body>

<h1 align="center" class="font-effect-fire-animation">Products</h1>
<div class="centerDiv">
    <ul>
        <li><a href="listprod.jsp">Shop</a></li>
        <li><a href="listorder.jsp">View Orders</a></li>
        <li style="float: right"><a href="">Cart</a></li>
    </ul>
    <div style="padding-top: 10px">
        <form method="get" action="listprod.jsp">
            <input type="text" name="productName" size="50">
            <input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
        </form>
        <%-- This table is where all our products are output to--%>
        <table>
            <% // Get product name to search for
                String name = request.getParameter("productName");

                //Note: Forces loading of SQL Server driver
                try {    // Load driver class
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                } catch (java.lang.ClassNotFoundException e) {
                    out.println("ClassNotFoundException: " + e);
                }

                // Make the connection
                String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
                String uid = "SA";
                String pw = "YourStrong@Passw0rd";

                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
                    String SQL = "SELECT * FROM product";
                    boolean hasName = (name != null) && (!name.equals(""));
                    PreparedStatement pstmt = null;
                    ResultSet rst = null;

                    if (!hasName) {
                        pstmt = con.prepareStatement(SQL);
                    } else {
                        name = "%" + name + "%";
                        SQL += " WHERE productName LIKE ?";
                        pstmt = con.prepareStatement(SQL);
                        pstmt.setString(1, name);
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
						String imageDesc = rst.getString(4);
                        String imageURL = rst.getString(5);
						String itemDesc = rst.getString(6);
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
                        out.println("<img src=\""+imageURL+"\" alt=\""+imageDesc+"\" style=\"width:100%\">");
						/**Prints productId with productName*/
						//out.println("<h1>"+productId+" "+productName+"</h1>");
                        out.println("<h1>"+productName+"</h1>");

                        out.println("<p class=\"price\">"+price+"</p>");
                        out.println("<p>"+itemDesc+"</p>");
						out.println("<p><button><a href=\""+addCartLink+"\">Add to Cart</a></button></p>");
                        out.println("</td>");
						counter++;
//						out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td> $" + price + "</td><td>" + rst.getString(4) + "</td><td>" + rst.getString(5) + "</td><td>" + rst.getString(6)
//                                + "</td><td>" + rst.getInt(7) + "</td><td><a href =" + addCartLink + ">Add To Cart</a></td></tr>");
                    }
					out.println("</tr>");


                    // For each product create a link of the form
                    // addcart.jsp?id=productId&name=productName&price=productPrice
                }
                // Close connection
                catch (SQLException ex) {
                    out.println(ex);
                }


            %>
        </table>
    </div>
</div>




</body>
</html>






<%--<tr>--%>
<%--    <td>--%>
<%--        <div class="card" style="background-color: red">--%>
<%--            <img src="jeans3.jpg" alt="Denim Jeans" style="width:100%">--%>
<%--            <h1>Test</h1>--%>
<%--            <p class="price">$19.99</p>--%>
<%--            <p>Some text about the jeans..</p>--%>
<%--            <p><button>Add to Cart</button></p>--%>
<%--        </div>--%>
<%--    </td>--%>
<%--    <td>--%>
<%--        <div class="card" style="background-color: blue">--%>
<%--            <img src="jeans3.jpg" alt="Denim Jeans" style="width:100%">--%>
<%--            <h1>Test</h1>--%>
<%--            <p class="price">$19.99</p>--%>
<%--            <p>Some text about the jeans..</p>--%>
<%--            <p><button>Add to Cart</button></p>--%>
<%--        </div>--%>
<%--    </td>--%>
<%--</tr>--%>
