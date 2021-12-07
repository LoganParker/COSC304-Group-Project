<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
@SuppressWarnings({"unchecked"}) HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
String id = request.getParameter("productId");
if (productList.containsKey(id)) {
    productList.remove(id);
    session.setAttribute("productList", productList);
}
%>
<jsp:forward page="showcart.jsp"/>