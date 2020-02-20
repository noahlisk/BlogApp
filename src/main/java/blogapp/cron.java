package blogapp;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.*;


public class cron extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		//get list of all posts on this day
		String blogAppName = "ourBlog";
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key userKey = KeyFactory.createKey("Users", blogAppName);
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		Date startDate = cal.getTime();
		Filter past24Filter = new FilterPredicate("date", FilterOperator.GREATER_THAN_OR_EQUAL, startDate);
		
		Query query = new Query("greeting", userKey).addSort("date", Query.SortDirection.DESCENDING).setFilter(past24Filter);
		List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(300));
		
		StringBuilder s = new StringBuilder();
		if(posts.isEmpty()) {
			s.append("no posts in the last day");
		}else {
			s.append("these are the posts from the last 24 hours...\n");
			for(Entity p: posts) {
				s.append(p.getProperty("title")+"/n");
				s.append(p.getProperty("content")+"/n");
				s.append("Posted by: "+p.getProperty("user")+" at "+p.getProperty("date")+"/n/n");
			}
		}
		
		Query query2 = new Query("email");
		List<Entity> subscribers = datastore.prepare(query2).asList(FetchOptions.Builder.withLimit(1000));
		
		if(subscribers.isEmpty()) {
			resp.setStatus(242);
		}
		
		for(Entity sub: subscribers) {
			Properties props = new Properties();
			Session sesh = Session.getDefaultInstance(props, null);
			try {
				Message msg = new MimeMessage(sesh);
				msg.setFrom(new InternetAddress("whatupfam@project13blogApp.appspotmal.com"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(sub.getProperty("user").toString()));
				msg.setSubject("New posts in the last 24 hours");
				String body = s.toString();
				msg.setText(body);
				Transport.send(msg);
			}catch(Exception ex) {
				
			}
		}
		
	}
}