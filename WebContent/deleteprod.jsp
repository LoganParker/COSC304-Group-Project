<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%
//String link = "?productId="+rst.getString(1)+"&productName="+rst.getString(2)+"&productPrice="+rst.getString(3)+"&productDesc="+rst.getString(6)+"&categoryId="+rst.getString(7);

String id = request.getParameter("productId");
out.println(id);
try{
    
    getConnection();
    String SQL = "DELETE FROM productinventory WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, id);
    pstmt.executeUpdate();

    SQL = "DELETE FROM orderproduct WHERE productId = ?";
    pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, id);
    pstmt.executeUpdate();

    SQL = "DELETE FROM product WHERE productId = ?";
    pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, id);
    pstmt.executeUpdate();
    
}catch (Exception ex) {
    out.println(ex);
}finally{
    closeConnection();
}

%>
<jsp:forward page="admin.jsp"/>