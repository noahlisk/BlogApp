package blogapp;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class SignServlet extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
			UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();
			
			String blogAppName = req.getParameter("blogAppName");
			
			Key blogAppKey = KeyFactory.createKey("blogAppName", blogAppName);
			String content = req.getParameter("content");
			Date date = new Date();
			Entity greeting = new Entity("Greeting", blogAppKey);
			greeting.setProperty("user", user);
			greeting.setProperty("date", date);
			greeting.setProperty("content", content);
			
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(greeting);
			
			resp.sendRedirect("/blogApp.jsp?blogAppName=" + blogAppName);
			
		}
			

}
