<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	
	try{
		authenticatedUser = validRegister(out,request,session);
	}
	catch(IOException e){
		System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("redirect.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validRegister(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String streetaddress = request.getParameter("streetaddr");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postal = request.getParameter("postalcode");
		String country = request.getParameter("country");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0) || firstname.length()==0 || lastname.length()==0)
				return null;

		try 
		{
			getConnection();
			String sql = "SELECT userid, password FROM customer WHERE customer.userid = ?" ;
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);		
	        ResultSet rst = pstmt.executeQuery();
			Boolean validUser;
			// Check if userId already exists, if it does, invalid userid, return null
			if(rst.next())
				return null;
			
			// TODO: Check if userId match some customer account. If so, set retStr to null, invalid
			sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, firstname);
			pstmt.setString(2, lastname);
			pstmt.setString(3, email);
			pstmt.setString(4, phone);
			pstmt.setString(5, streetaddress);
			pstmt.setString(6, city);
			pstmt.setString(7, state);
			pstmt.setString(8, postal);
			pstmt.setString(9, country);
			pstmt.setString(10, username);
			pstmt.setString(11, password);


			int result = pstmt.executeUpdate();
			out.println(result);
			if(result == 1 ){
				return username; //insert works!
			} else {
				return null;     //insert fails :(
			}
          
		
		
		} catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			try {
				closeConnection();
			} catch (SQLException ex) {
				out.println(ex);
			}
			
			
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			
		} else {
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");
		}
		return retStr;
	}
%>

