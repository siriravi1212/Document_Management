<%@page import="java.sql.DriverManager"%>
<%@page import="http.HttpURLConnectionExample"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.IOException"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.select.Elements"%>


<%

    String urll = request.getParameter("url");

    //  try {
    String[] arr = null;

    // fetch the document over HTTP
    Document doc = Jsoup.connect(urll).get();

    // get the page title
    String title = doc.title();
    System.out.println("title: " + title);

    // get all links in page
    Elements links = doc.select("a[href]");
    String work = links.text();
    System.out.println(work);
    //System.out.println("text: " + links.text());
    //  for (Element link : links) {
    // get the value from the href attribute
    // System.out.println("\nlink: " + link.attr("href"));
    // System.out.println("text: " + link.text());
    //break;
    // }
    arr = work.split(" ");

   

            String driverName = "com.mysql.jdbc.Driver";
            String connectionUrl = "jdbc:mysql://localhost:3306/";
            String dbName = "document?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
            String userId = "root";
            String password = "";

            try {
                Class.forName(driverName);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DriverManager.getConnection(
                        connectionUrl + dbName, userId, password);
                statement = connection.createStatement();
                statement.executeUpdate("truncate doc");
int bookID=0;
  HttpURLConnectionExample htt = new HttpURLConnectionExample();
 for (int i=0; i < arr.length; i++)
 {
   
       String sql="select count(word) from doc where word in('"+arr[i]+"')";
       resultSet = statement.executeQuery(sql);
       if(resultSet.next()){
           
        bookID = resultSet.getInt(1); //IDTable
       }
      
      if(bookID==0)
      {
           String ans = htt.searchSynonym(arr[i]);
     int in = statement.executeUpdate("insert into doc(url,word,freq,synon) values ('" + urll + "','" + arr[i]+ "',1,'"+ans+"')");
      }
      else
      {
       
       statement.executeUpdate(" update doc set freq=freq+1 where word='"+arr[i]+"';");
      }
 }
%> <table cellpadding="1"  cellspacing="1" border="1" bordercolor="gray">
            <tr>
               <td>ID</td>
                <td>URL</td>
               <td>Words</td>
               <td>Frequency</td>
			   <td>Synonyms</td>
			  
            </tr>
			<% String sql = "SELECT * FROM doc";

resultSet = statement.executeQuery(sql);
while (resultSet.next()) {
	
%>
            <tr>
				<td><%=resultSet.getString("ID")%></td>
				<td><%=resultSet.getString("url")%></td>
				<td><%=resultSet.getString("word")%></td>
				<td><%=resultSet.getString("freq")%></td>
				<td><%=resultSet.getString("synon")%></td>
			</tr>
            <% 
               }
        } catch (Exception e) {
            e.printStackTrace();
        }
            %></table>
      <input type="button" onclick="window.location='reg2.jsp'" value="load" />

