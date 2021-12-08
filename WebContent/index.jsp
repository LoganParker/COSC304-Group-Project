<!DOCTYPE html>
<html>
<head>
        <title>D&D Pets Inc - Home</title>
</head>
<body>
<%@include file="header.jsp"%>
<%@include file="jdbc.jsp"%>
<div style="margin:0 auto;text-align:center;display:inline">
<div class="centerDiv"style="background-color: white">
<%
        out.println("<img src=\"https://c.tenor.com/xOQiRI01CkQAAAAC/dragon-gold.gif\">");
        out.println("<p>Welcome! To start shopping, visit <a href=\"listprod.jsp\">Begin Shopping!</a></p>");
        String sql = "";
		PreparedStatement pstmt = null;
		boolean hasOrdered = false;
		String custId =(String) session.getAttribute("customerId");
        out.println("<hr>");
		try{
            getConnection();
			if(session.getAttribute("authenticatedUser") != null){
				sql = "SELECT * FROM ordersummary WHERE customerId = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, custId);
				ResultSet rst1 = pstmt.executeQuery();
				hasOrdered = rst1.next();
			}
			if(hasOrdered){
				sql = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc, SUM(orderproduct.quantity) AS totalOrdered  FROM product RIGHT JOIN orderproduct ON orderproduct.productId = product.productId LEFT JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId LEFT JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.customerId = ? GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY totalOrdered DESC, product.productName";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, custId);
			}	
			else{
					sql = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc, SUM(orderproduct.quantity) as amountSold FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId GROUP BY product.productId, product.productName, product.productPrice, product.productImageURL, product.productImage, product.productDesc ORDER BY amountSold DESC, product.productName";
					pstmt = con.prepareStatement(sql);
			}
			ResultSet rst = pstmt.executeQuery();
			if(rst.next()){
				String productId = rst.getString(1);
                String productName = rst.getString(2);
                String price = rst.getString(3);
                String imageURL = rst.getString(4);
				String imageDesc = rst.getString(5);
                String itemDesc = rst.getString(6);
				out.println("<h4>Not sure where to begin? Based on your profile we suggest the following item:</h4>");
                // addcart.jsp?id=productId&name=productName&price=productPrice
                String addCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + price;
				out.println("<div class = \"card\" style=\"max-width: 30%;\">");
                out.println("<img src=\""+imageURL+"\" alt=\""+imageDesc+"\" style=\"max-width:50%; max-height:50%\">");
				/**Prints productId with productName*/
				//out.println("<h1>"+productId+" "+productName+"</h1>");
                out.println("<h1><a href = \"product.jsp?id="+productId+"\">"+productName+"</a></h1>");
                out.println("<p class=\"price\">"+price+"</p>");
                out.println("<p>"+itemDesc+"</p>");
				out.println("<p><button><a href=\""+addCartLink+"\">Add to Cart</a></button></p>");
			}

        }catch(Exception ex){
			out.println(ex);
			throw(ex);
        }finally{
			closeConnection();
		}
%>
</div>
</div>

</body>
</html>


