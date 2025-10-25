package com.tech.blog.servlets;

import com.tech.blog.dao.PostDao;
import com.tech.blog.helper.ConnectionProvider;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RemovePost")
public class RemovePostServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("post_id"));
            
            PostDao postDao = new PostDao(ConnectionProvider.getConnection());
            boolean deleted = postDao.deletePost(postId);
            
            if (deleted) {
                response.sendRedirect("my_posts.jsp?msg=deleted");
            } else {
                response.sendRedirect("my_posts.jsp?error=delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my_posts.jsp?error=exception");
        }
    }
}
