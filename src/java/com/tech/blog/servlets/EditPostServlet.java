package com.tech.blog.servlets;

import com.tech.blog.dao.PostDao;
import com.tech.blog.entities.Post;
import com.tech.blog.helper.ConnectionProvider;
import java.io.IOException;
import java.io.File;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/EditPost")
@MultipartConfig
public class EditPostServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("post_id"));
            String title = request.getParameter("pTitle");
            String content = request.getParameter("pContent");
            String code = request.getParameter("pCode");
            int categoryId = Integer.parseInt(request.getParameter("cid"));
            Part part = request.getPart("pic");
            
            PostDao postDao = new PostDao(ConnectionProvider.getConnection());
            Post post = postDao.getPostByPostId(postId);
            
            // Update post fields
            post.setpTitle(title);
            post.setpContent(content);
            post.setpCode(code);
            post.setCatId(categoryId);
            
            // Handle image upload if new image provided
            if (part != null && part.getSize() > 0) {
                String imageName = part.getSubmittedFileName();
                post.setpPic(imageName);
                
                // Save to blog_pics folder
                String path = request.getServletContext().getRealPath("/") + "blog_pics" + File.separator + imageName;
                part.write(path);
            }
            
            // Update in database
            boolean updated = postDao.updatePost(post);
            
            if (updated) {
                response.sendRedirect("my_posts.jsp?msg=updated");
            } else {
                response.sendRedirect("edit_post.jsp?post_id=" + postId + "&error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my_posts.jsp?error=exception");
        }
    }
}
