<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Database Refresh</title>
    <meta http-equiv="refresh" content="3;url=admin.jsp" />

</head>
<body>

<h1>Connecting to database.</h1><br><br>
<img src="https://i.gifer.com/embedded/download/CgLt.gif">
<%
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";




    Connection con = DriverManager.getConnection(url, uid, pw);

    String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";
    
    try {
        // Create statement
        Statement stmt = con.createStatement();

        Scanner scanner = new Scanner(new File(fileName));
        // Read commands separated by ;
        scanner.useDelimiter(";");
        while (scanner.hasNext()) {
            String command = scanner.next();
            if (command.trim().equals(""))
                continue;
            // out.print(command);        // Uncomment if want to see commands executed
            try {
                stmt.execute(command);
            } catch (Exception e) {    // Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
                out.print(e);
            }
        }
        scanner.close();

        out.print("<br><br><h1>Database loaded. You will be redirected shortly</h1>");
    } catch (Exception e) {
        out.print(e);
    }
%>
</body>
</html> 
