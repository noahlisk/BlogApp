<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
  <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>

 

  <body>

 

<%
    String blogAppName = "ourBlog";
	int numPostsShown = 5;
	
	try{
		if(request.getParameter("see").equals("all")){
			numPostsShown = 300;
		}
	}catch(Exception e){
		
	}

    pageContext.setAttribute("blogAppName", blogAppName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {
      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)

<a href=/postBlog> Post to blog.</a>

</p>

<%
    } else {
%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to post something to our blog.</p>

<%
    }
%>

 

<%

	if(user != null){
%>
	<form action="${pageContext.request.contextPath}/subscribe" method="post">
		<input type="submit" name="subscribe" value="Subscribe"/>
		<input type="submit" name="unsubscribe" value="Unsubscribe"/>
	</form>
<%
	}else{
%>
	<h5>Login to subscribe to our blog</h5>
<%	
	}

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key userKey = KeyFactory.createKey("Users", blogAppName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

    Query query = new Query("Greeting", userKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(numPostsShown));
    
    for(Entity post: greetings){
    	pageContext.setAttribute("post_user", post.getProperty("user"));
    	pageContext.setAttribute("post_content", post.getProperty("content"));
    	pageContext.setAttribute("post_title", post.getProperty("title"));
    	pageContext.setAttribute("post_date", post.getProperty("date"));
    	
%>
    	<h2>${fn:escapeXml(post_title)}</h2>
    	<blockquote>${fn:escapeXml(post_content)}</blockquote>
    	<h5>${fn:escapeXml(post_date)}</h5>
    	<h5>${fn:escapeXml(post_user.nickname)}</h5>

<%    	
    }
        
%>

<form action="/seeAll" method="post">
	<input type="submit" name="seeAll" value="See all previous posts">
	<input type="hidden" name="see" value="all">
</form>
 

  </body>

</html>

