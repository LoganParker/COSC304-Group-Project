<head>
    <link href="https://fonts.googleapis.com/css?family=MedievalSharp&effect=fire-animation" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="styles.css" rel="stylesheet">
</head>
<div class="headerBackground">
    <h1 class="headerText font-effect-fire-animation">D&D Pets Inc</h1>
    <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="listprod.jsp">Begin Shopping</a></li>
        <li><a href="listorder.jsp">View Orders</a></li>

        


        <%
        String userName = (String) session.getAttribute("authenticatedUser");
        if(userName !=null){
            //User is logged in 
            out.println("<li style=\"float: right\"><a href=\"logout.jsp\">Log Out</a></li>");
            out.println("<li style=\"float: right\"><a href=\"customer.jsp\">"+userName+"</a></li>");
        }else{
            //User is not logged in
            out.println("<li style=\"float: right\"><a href=\"login.jsp\">Log In</a></li>");
        }
            // TODO: Implement admin section
//        if(loggedIn){
//			show customer name linked to cust info;
//			if(admin){
//				show admin panel
//            }
//			login
//        }else{
//			login
//        }
//
        %>
        <li style="float: right"><a href="showcart.jsp">Cart</a></li>
    </ul>
</div>

<%--
    TODO: Display user name that is logged in (or nothing if not logged in)
    <h2 align="center"><a href="customer.jsp">Customer Info</a></h2>
    <h2 align="center"><a href="admin.jsp">Administrators</a></h2>
    <h2 align="center"><a href="logout.jsp">Log out</a></h2>
--%>
