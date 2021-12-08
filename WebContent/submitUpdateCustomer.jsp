<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%
try{
    getConnection();
        //     customerId          INT IDENTITY,
        // firstName           VARCHAR(40), 2
        // lastName            VARCHAR(40), 3
        // email               VARCHAR(50), 4 
        // phonenum            VARCHAR(20),5
        // address             VARCHAR(50),6
        // city                VARCHAR(40),7
        // state               VARCHAR(20),8
        // postalCode          VARCHAR(20),9
        // country             VARCHAR(40),10
        // userid              VARCHAR(20),11
        // password            VARCHAR(30),12
    String sql = "SELECT userid FROM customer WHERE userid = ? AND customerId <> ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, request.getParameter("username"));
    pstmt.setString(2, request.getParameter("customerId"));	
    ResultSet rst = pstmt.executeQuery();
    // Check if userId already exists, if it does, invalid userid, return null
    if(rst.next()){
        response.sendRedirect("redirect.jsp");	
    }
    else{
        String[] name = {"firstname","lastname","email", "phone","streetaddr","city","state","postalcode","country","username","password"};
        ArrayList<String> rsd = new ArrayList<String>();   
        for(String i:name){
            rsd.add(request.getParameter(i));
        }
    
        sql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, userid = ?, password=? WHERE customerId = ?";
        pstmt = con.prepareStatement(sql);
        int i = 1;
        for(String item:rsd){
            pstmt.setString(i++, item);
        }
        pstmt.setString(12,request.getParameter("customerId"));
        out.println(sql);
        pstmt.executeUpdate();
        session.setAttribute("authenticatedUser",request.getParameter("username"));
        response.sendRedirect("customer.jsp");	
    }
    
    
    
}catch (SQLException ex) {
    out.println(ex);
}finally{
    closeConnection();
}

%>