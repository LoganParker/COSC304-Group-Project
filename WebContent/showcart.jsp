<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <title>D&D Pets Inc. - Cart</title>
    <script type="text/javascript">
        const xhttp = new XMLHttpRequest();

        xhttp.onload = function delete_item(clicked_id)
        {
        window.alert(clicked_id);

         var prodList =  "<%= session.getAttribute("productList")%>"
         window.alert(prodList);
        }

        xhttp.open("GET", "", true);
      </script>
</head>
<body>
<%@include file="header.jsp"%>
<h2 align="center" class="subheaderText font-effect-fire-animation">Your Cart</h1>
<div style="margin:0 auto;text-align:center;display:inline">
<div class="centerDiv"style="background-color: white">
    <div>

<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"}) HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null) {
        out.println("<h1>Your shopping cart is empty!</h1>");
        productList = new HashMap<String, ArrayList<Object>>();
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        out.println("<form name='updateCart' method='GET' action='updateCart.jsp'>");
        out.print("<table style=\"display: inline;\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th><th><input type=\"submit\" value=\"Update\"></th></tr>");
        

        double total = 0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
            if (product.size() < 4) {
                out.println("Expected product with four entries. Got: " + product);
                continue;
            }
            out.println("<tr>");
            // Prod ID
            out.print("<td>" + product.get(0) + "</td>");
            // Prod Name
            out.print("<td>" + product.get(1) + "</td>");
            // Quantity
            out.print("<td align=\"center\"><input type=\"number\" name=\"" +product.get(0)+"\" id=quantity min=0 max=99 value=\""+product.get(3)+"\"></td>");
            Object price = product.get(2);
            Object itemqty = product.get(3);
            double pr = 0;
            int qty = 0;
            try {
                pr = Double.parseDouble(price.toString());
            } catch (Exception e) {
                out.println("Invalid price for product: " + product.get(0) + " price: " + price);
            }
            try {
                qty = Integer.parseInt(itemqty.toString());
            } catch (Exception e) {
                out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
            }
            // Price
            out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
            //Price * Quantity
            out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");
            // Delete item
            String deletionLink = "removeFromCart.jsp"+"?productId="+product.get(0);
            out.print("<td><button type=button><a href=\""+deletionLink+"\">Remove</a></button></td>");

            out.println("</tr>");
            total = total + pr * qty;
        }




        out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>" + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
        out.println("</table></form>");

        out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
    }
%>

<h2><a href="listprod.jsp">Continue Shopping</a></h2>

    </div>
</div>
</div>
</body>
</html> 