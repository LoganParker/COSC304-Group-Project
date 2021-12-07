<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%
try{
    getConnection();
    String[] name = {"productName","productPrice","productDesc", "categoryId","productId"};
    ArrayList<String> rsd = new ArrayList<String>();   
    for(String i:name){
        rsd.add(request.getParameter(i));
    }

    String SQL = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    int i = 1;
    for(String item:rsd){
        pstmt.setString(i++, item);
    }
    pstmt.executeUpdate();
}catch (Exception ex) {
    out.println(ex);
}finally{
    closeConnection();
}

%>
<jsp:forward page="admin.jsp"/>