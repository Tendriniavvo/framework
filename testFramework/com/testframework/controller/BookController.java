package testFramework.com.testframework.controller;

import framework.annotation.Controller;
import framework.annotation.GetMapping;
import framework.utilitaire.ModelAndView;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class BookController {

    @GetMapping("/book")
    public String root() {
        return "book root";
    }

    @GetMapping("/book/{id}")
    public ModelAndView getBookById(HttpServletRequest request) {
        // Path variable is exposed by FrontServlet as request attribute "id"
        String id = (String) request.getAttribute("id");
        ModelAndView mv = new ModelAndView("/bookView.jsp");
        mv.addObject("bookId", id);
        return mv;
    }
}
