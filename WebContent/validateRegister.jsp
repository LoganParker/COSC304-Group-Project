<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

	try{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e){
		System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validRegister(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		/./
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0) || firstname.length()==0 || lastname.length()==0)
				return null;


		try 
		{
			getConnection();
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT userid, password FROM customer WHERE customer.userid = ? AND customer.password = ?" ;
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);
			pstmt.setString(2, password);

			rst = pstmt.executeQuery();
			if(rst.next()){
				retStr = rst.getString(1);
			}
		
		} catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{

			
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

