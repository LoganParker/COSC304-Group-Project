<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>

<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"}) HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null) {    // No products currently in list.  Create a list.
        out.println("<jsp:forward page=\"showcart.jsp\"/>");
    }
    // Get product information for each product
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    //For each item in the productList
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4) {
            out.println("Expected product with four entries. Got: " + product);
            continue;
        }
        //Product ID

        String currentId = product.get(0).toString();

        // New quantity passed to page from the request
        int newQuantity = Integer.parseInt(request.getParameter(currentId));
        //Update Quantity
        
        if (productList.containsKey(currentId)) {
            if(newQuantity <= 0){
                productList.remove(currentId);
            }else{
                product = (ArrayList<Object>) productList.get(currentId);
                int curAmount = ((Integer) newQuantity).intValue();
                product.set(3, curAmount);
            }
        }
    }
    // Update session
    session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp"/>
