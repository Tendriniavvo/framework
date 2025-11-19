package testFramework.com.testframework.controller;

import framework.annotation.Controller;
import framework.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class BookController {

    @GetMapping("/book/{id}")
    public String getBookById(HttpServletRequest request) {
        // Path variable is exposed by FrontServlet as request attribute "id"
        String id = (String) request.getAttribute("id");
        return "Book id from path variable = " + id;
    }
}
